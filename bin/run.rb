#!/usr/bin/env ruby

require_relative '../lib/fooda-bot'

slack = Slacker.new(Slack::Web::Client.new)
storage = Storage.new(Redis.new)

event = Event.new(Connection.new(ENV['FOODA_URL']), slack, storage)

if event&.today? && event.restaurants.any?
  message = slack.send(event.slack_format)
  event.save_as_latest if message
end
