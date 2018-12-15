require 'json'

class Storage
  LATEST_KEY = 'latest'

  attr_reader :redis

  def initialize(redis)
    @redis = redis
    @latest_cache = []
  end

  def get_latest
    parse_latest(redis.get(encode(LATEST_KEY)))
  end

  def add_event(event)
    add_to_latest(event.restaurants.map(&:name))
  end

  def save_latest
    return unless @latest_cache.any?
    redis.set(encode(LATEST_KEY), { time: Time.new, names: @latest_cache }.to_json)
    @latest_cache = []
  end

  def push(name, value)
    redis.lpush(encode(name), value)
  end

  def lookup(name)
    redis.lindex(encode(name), 0)
  end

  private

  def add_to_latest(names)
    @latest_cache += names
  end

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
