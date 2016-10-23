require 'json'

class Storage
  LATEST_KEY = 'latest-restaurant'

  attr_reader :redis

  def initialize
    @redis = Redis.new
  end

  def get_latest
    parse_latest(redis.get(LATEST_KEY))
  end

  def set_latest(name)
    redis.set(LATEST_KEY, { time: Time.new, name: name }.to_json)
  end

  def push(name, value)
    redis.lpush(name, value)
  end

  def lookup(name)
    redis.lindex(name, 0)
  end

  private

  LatestEvent = Struct.new(:time, :name)

  def parse_latest(latest)
    return nil unless latest
    result = JSON.parse(latest)
    LatestEvent.new(Time.parse(result['time']), result['name'])
  end
end
