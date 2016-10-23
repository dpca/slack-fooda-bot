[![Build Status](https://travis-ci.org/dpca/slack-fooda-bot.svg?branch=master)](https://travis-ci.org/dpca/slack-fooda-bot)
[![Code Climate](https://codeclimate.com/github/dpca/slack-fooda-bot/badges/gpa.svg)](https://codeclimate.com/github/dpca/slack-fooda-bot)

* * *

# fooda-bot

Slack bot that looks up current events from [Fooda](https://www.fooda.com/) and
remembers reactions for when they come around again.

## Setup

`bundle install` and set the following in `.env`:

* SLACK_API_TOKEN
* SLACK_CHANNEL
* SLACK_USERNAME
* SLACK_ICON_EMOJI
* FOODA_URL

Fooda-bot uses [Redis](http://redis.io/) to remember its message history and
look up the last restaurant reactions. Ensure that redis is either running
locally or set `REDIS_URL` in your `.env` or environment to point it to a redis
instance. All fields that fooda-bot sets in redis are prefixed with
"fooda-bot:".

## Run

Use `bin/run.rb` to look up and post about the day's fooda event in the
morning, and `bin/ask_for_ratings.rb` to ask for reactions in the afternoon.
These two actions are separate to increase likelihood that users remember to
leave an emoji rating - they don't have to go back to the morning's message
after they've eaten lunch.

## Test

```
bundle exec rspec spec
```
