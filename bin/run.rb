#!/usr/bin/env ruby

require_relative '../lib/fooda-bot'

slack = Slacker.new(Slack::Web::Client.new)
storage = Storage.new(Redis.new)
reaction_formatter = ReactionFormatter.new(slack, storage)

event = Event.new(Connection.new(ENV['FOODA_URL']), reaction_formatter)

if event&.today? && event.restaurants.any?
  slack.add_attachment(event.title, event.slack_format)
  storage.add_event(event)
end

if ENV['PEACH_HOME_LOCATION_ID']
  peach = Peach.new(reaction_formatter)
  if peach.restaurants.any?
    slack.add_attachment(peach.title, peach.slack_format)
  end
end

message = slack.send('Hey there! Here are your lunch options for today.')
storage.save_latest if message
