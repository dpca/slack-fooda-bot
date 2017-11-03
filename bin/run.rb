#!/usr/bin/env ruby

require_relative '../lib/fooda-bot'

slack = Slacker.new(Slack::Web::Client.new)
storage = Storage.new(Redis.new)

event = Event.new(RestClient.get(ENV['FOODA_URL']), slack, storage)

if event&.today?
  message = slack.send(event.slack_format)
  event.save_as_latest if message
end
