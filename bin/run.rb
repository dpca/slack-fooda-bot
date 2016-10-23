#!/usr/bin/env ruby

require_relative '../lib/fooda-bot'

slack = Slacker.new(Slack::Web::Client.new)
storage = Storage.new

event = Event.new(RestClient.get('fooda.com/idb'))

if event && event.today?
  reactions = slack.reactions(storage.lookup(event.name))
  message = slack.send(SlackEventFormatter.new(event, reactions).format)
  storage.set_latest(event.name) if message
end
