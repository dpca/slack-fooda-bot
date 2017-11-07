#!/usr/bin/env ruby

require_relative '../lib/fooda-bot'

slack = Slacker.new(Slack::Web::Client.new)
storage = Storage.new(Redis.new)

event = storage.get_latest

if event && TimeHelpers.today?(event.time)
  event.names.each do |restaurant|
    message = slack.send("How did you like #{restaurant}? React with an emoji on this message!")
    storage.push(restaurant, message.ts) if message
  end
end
