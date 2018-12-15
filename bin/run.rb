#!/usr/bin/env ruby

require_relative '../lib/fooda-bot'

slack = Slacker.new(Slack::Web::Client.new)
storage = Storage.new(Redis.new)

event = Event.new(Connection.new(ENV['FOODA_URL']), slack, storage)

if event&.today? && event.restaurants.any?
  slack.add_attachment('Fooda', event.slack_format)
  storage.add_event(event)
end

message = slack.send('Hey there! Here are your lunch options for today.')
storage.save_latest if message
