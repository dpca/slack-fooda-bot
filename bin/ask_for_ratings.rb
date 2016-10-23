#!/usr/bin/env ruby

require_relative '../lib/fooda-bot'

slack = Slacker.new(Slack::Web::Client.new)
storage = Storage.new(Redis.new)

event = storage.get_latest

if event && TimeHelpers.today?(event.time)
  message = slack.send("How did you like #{event.name}? React with an emoji on this message!")
  storage.push(event.name, message.ts) if message
end
