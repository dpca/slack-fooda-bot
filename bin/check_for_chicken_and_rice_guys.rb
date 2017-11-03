#!/usr/bin/env ruby

require 'date'
require_relative '../lib/fooda-bot'

slack = Slacker.new(Slack::Web::Client.new)
storage = Storage.new(Redis.new)

tomorrow = Date.today + 1

response = RestClient.get(ENV['FOODA_URL'])

event = Event.new(
  RestClient.get(
    'app.fooda.com/my',
    params: { date: tomorrow.strftime('%F') },
    cookies: response.cookies
  ),
  slack,
  storage
)

if event&.tomorrow? && event.restaurants.any?(&:chicken_and_rice_guys?)
  slack.send("Attention everyone! The greatest fooda popup in the world will be here once again tomorrow! That's right, it's chicken and rice guys!!!!\n:chickenandriceguys: :chickenandriceguys: :chickenandriceguys: :chickenandriceguys: :chickenandriceguys:")
end
