require 'nokogiri'
require 'open-uri'


module Connpass
  CONNPASS_REGEXP = %r!http://connpass\.com/user/([^/]*)/!
  TWITTER_REGEXP = %r!https://twitter\.com/[^?]*\?screen_name=(.*)!
  FACEBOOK_REGEXP = %r!https://www\.facebook\.com/(.*)!
  GITHUB_REGEXP = %r!https://github\.com/(.*)!
end

class Connpass::Scraper
  attr_reader :users

  def initialize(event_id)
    @event_id = event_id
    url = "http://connpass.com/event/#{@event_id}/participation/"
    @doc = Nokogiri::HTML(open url)
    @users = []
  end

  def scrape
    @users = []
    @doc.xpath('//tbody/tr').each do |conpass|
      conpass.css('td.user').each do |connpass_user|
        user = {}
        connpass_link = connpass_user.css('p.display_name a').first
        if connpass_link and Connpass::CONNPASS_REGEXP =~ connpass_link[:href] then
          user[:connpass] = $1
        end
        conpass.css('td.social').each do |socials|
          socials.children.each do |social|
            social_url = social[:href]
            if Connpass::TWITTER_REGEXP =~ social_url then
              user[:twitter] = $1
            end
            if Connpass::FACEBOOK_REGEXP =~ social_url then
              user[:facebook] = $1
            end
            if Connpass::GITHUB_REGEXP =~ social_url then
              user[:github] = $1
            end
          end
        end
        @users << user
      end
    end
  end
end

