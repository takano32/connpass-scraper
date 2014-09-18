#!/usr/bin/env ruby

require_relative './connpass'

s = Connpass::Scraper::Event.new(6300)
s.scrape
users = s.users

users.each do |user|
  if id = user[:twitter] then
    puts "Twitter: #{id}"
  end
end

