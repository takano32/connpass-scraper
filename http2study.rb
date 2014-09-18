#!/usr/bin/env ruby

require_relative './connpass'

s = Connpass::Scraper::Series.new('http2study')
s.scrape
eids = s.event_ids

users = eids.inject([]) do |users, id|
  e = Connpass::Scraper::Event.new(id)
  e.scrape
  users + e.users
end.uniq

users.each do |user|
  if id = user[:twitter] then
    puts id
  end
end

