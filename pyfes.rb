#!/usr/bin/env ruby

require_relative './connpass'

# http://connpass.com/series/162/
pyfes = [952, 951, 950, 1581, 1580, 1579, 2218, 2217, 2256, 4273]

# http://connpass.com/series/217/
pyfes_yep = [1247, 3941]

users = (pyfes + pyfes_yep).inject([]) do |users, id|
  s = Connpass::Scraper.new(id)
  s.scrape
  users + s.users
end.uniq

users.each do |user|
  if id = user[:twitter] then
    puts "Twitter: #{id}"
  end
end

