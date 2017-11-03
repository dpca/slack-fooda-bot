describe Storage do
  describe '#get_latest' do
    it 'gets the latest event info from redis' do
      time = Time.new
      redis = instance_double('Redis')
      expect(redis).to receive(:get).with('fooda-bot:latest').and_return({ time: time, names: ['Foo'] }.to_json)
      storage = Storage.new(redis)
      latest_event = storage.get_latest
      expect(latest_event).to be_a(Storage::LatestEvent)
      expect(latest_event.time.round).to eq(time.round)
      expect(latest_event.names).to eq(['Foo'])
    end
  end

  describe '#set_latest' do
    it 'sets the latest event info in redis' do
      time = Time.new
      allow(Time).to receive(:new).and_return(time)
      redis = instance_double('Redis')
      expect(redis).to receive(:set).with('fooda-bot:latest', { time: time, names: ['Foo'] }.to_json)
      storage = Storage.new(redis)
      storage.set_latest(['Foo'])
    end
  end

  describe '#push' do
    it 'adds to a redis list' do
      redis = instance_double('Redis')
      expect(redis).to receive(:lpush).with('fooda-bot:Foo', 1234)
      storage = Storage.new(redis)
      storage.push('Foo', 1234)
    end
  end

  describe '#lookup' do
    it 'fetches from the front of redis list' do
      redis = instance_double('Redis')
      expect(redis).to receive(:lindex).with('fooda-bot:Foo', 0).and_return(1234)
      storage = Storage.new(redis)
      timestamp = storage.lookup('Foo')
      expect(timestamp).to eq(1234)
    end
  end
end
