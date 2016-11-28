[![Build Status](https://travis-ci.org/dpca/slack-fooda-bot.svg?branch=master)](https://travis-ci.org/dpca/slack-fooda-bot)
[![Code Climate](https://codeclimate.com/github/dpca/slack-fooda-bot/badges/gpa.svg)](https://codeclimate.com/github/dpca/slack-fooda-bot)
[![Test Coverage](https://codeclimate.com/github/dpca/slack-fooda-bot/badges/coverage.svg)](https://codeclimate.com/github/dpca/slack-fooda-bot/coverage)

* * *

# fooda-bot

Slack bot that looks up current events from [Fooda](https://www.fooda.com/) and
remembers reactions for when they come around again. Lets everyone in a
channel, such as "#lunch", know both the restaurant popup for the day and the
reactions that were used when it last came around.

## Setup

`bundle install` and set the following in `.env`:

* `SLACK_API_TOKEN` - Slack token (see below)
* `SLACK_CHANNEL` - channel to post in
* `SLACK_USERNAME` - bot name
* `SLACK_ICON_EMOJI` - bot icon
* `FOODA_URL` - fooda url for your popup space, e.g. "fooda.com/idb"

Fooda-bot uses [Redis](http://redis.io/) to remember its message history and
look up the last restaurant reactions. Ensure that redis is either running
locally or set `REDIS_URL` in your `.env` or environment to point it to a redis
instance. All fields that fooda-bot sets in redis are prefixed with
"fooda-bot:".

You can request a token for testing purposes from
https://api.slack.com/docs/oauth-test-tokens but should use a bot token from
https://my.slack.com/services/new/bot for a real deployment. Read more about
bot users here: https://api.slack.com/bot-users.

## Run

Use `bin/run.rb` to look up and post about the day's fooda event in the
morning, and `bin/ask_for_ratings.rb` to ask for reactions in the afternoon.
These two actions are separate to increase likelihood that users remember to
leave an emoji rating - they don't have to go back to the morning's message
after they've eaten lunch.

To run on a schedule, use cron. For example, `0 11 * * 1-5 bin/run.rb` to run
at 11 AM on weekdays and `0 14 * * 1-5 bin/ask_for_ratings.rb` to ask for
ratings at 2 PM.

## Test

```
bundle exec rspec spec
```
