#!/usr/bin/env ruby

require_relative './connpass'

# 7636
users = [5769, 8120].inject([]) do |users, id|
  s = Connpass::Scraper::Event.new(id)
  s.scrape
  users + s.users
end.uniq

users.each do |user|
  if id = user[:twitter] then
    puts "Twitter: #{id}"
  end
end

