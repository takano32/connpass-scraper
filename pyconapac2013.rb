#!/usr/bin/env ruby

require_relative './connpass'

users = [2703, 2704, 3127].inject([]) do |users, id|
  s = Connpass::Scraper.new(id)
  s.scrape
  users + s.users
end.uniq

users.each do |user|
  if id = user[:twitter] then
    puts "Twitter: #{id}"
  end
end

