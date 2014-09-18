require 'nokogiri'
require 'open-uri'


module Connpass
  module Scraper
    CONNPASS_REGEXP = %r!http://connpass\.com/user/([^/]*)/!
    TWITTER_REGEXP = %r!https://twitter\.com/[^?]*\?screen_name=(.*)!
    FACEBOOK_REGEXP = %r!https://www\.facebook\.com/(.*)!
    GITHUB_REGEXP = %r!https://github\.com/(.*)!
  end
end

class Connpass::Scraper::Series
  attr_reader :event_ids

  def initialize(series_id)
    @event_ids = []
    @series_id = series_id
    url = "http://connpass.com/series/#{series_id}"
    @doc = Nokogiri::HTML(open url)
  end

  def scrape
    @event_ids = []
    @doc.css('a.url').each do |link|
      if link[:href] =~ %r!http://([a-z]*\.)?connpass.com/event/([0-9]+)/! then
        @event_ids << $2.to_i
      end
    end
  end
end

class Connpass::Scraper::Event
  attr_reader :users

  def initialize(event_id)
    @event_id = event_id
    url = "http://connpass.com/event/#{@event_id}/participation/"
    begin
      @doc = Nokogiri::HTML(open url)
    rescue OpenURI::HTTPError => e
      @doc = nil if e.message == '404 NOT FOUND'
    end
    @users = []
  end

  def scrape
    return if @doc.nil?
    @users = []
    @doc.xpath('//tbody/tr').each do |conpass|
      conpass.css('td.user').each do |connpass_user|
        user = {}
        connpass_link = connpass_user.css('p.display_name a').first
        if connpass_link and Connpass::Scraper::CONNPASS_REGEXP =~ connpass_link[:href] then
          user[:connpass] = $1
        end
        conpass.css('td.social').each do |socials|
          socials.children.each do |social|
            social_url = social[:href]
            if Connpass::Scraper::TWITTER_REGEXP =~ social_url then
              user[:twitter] = $1
            end
            if Connpass::Scraper::FACEBOOK_REGEXP =~ social_url then
              user[:facebook] = $1
            end
            if Connpass::Scraper::GITHUB_REGEXP =~ social_url then
              user[:github] = $1
            end
          end
        end
        @users << user
      end
    end
  end
end


