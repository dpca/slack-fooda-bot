require 'json'

class Storage
  LATEST_KEY = 'latest'

  attr_reader :redis

  def initialize(redis)
    @redis = redis
  end

  def get_latest
    parse_latest(redis.get(encode(LATEST_KEY)))
  end

  def set_latest(names)
    redis.set(encode(LATEST_KEY), { time: Time.new, names: names }.to_json)
  end

  def push(name, value)
    redis.lpush(encode(name), value)
  end

  def lookup(name)
    redis.lindex(encode(name), 0)
  end

  private

  def encode(name)
    "fooda-bot:#{name}"
  end

  LatestEvent = Struct.new(:time, :names)

  def parse_latest(latest)
    return nil unless latest
    result = JSON.parse(latest)
    LatestEvent.new(Time.parse(result['time']), result['names'])
  end
end
