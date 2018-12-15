describe Slacker do
  before(:all) do
    ENV['SLACK_CHANNEL'] = 'slack-test-channel'
    ENV['SLACK_USERNAME'] = 'slack-test-username'
    ENV['SLACK_ICON_EMOJI'] = 'slack-test-icon-emoji'
  end

  before(:each) do
    @client = instance_double('Slack::Web::Client')
  end

  FakeResponse = Struct.new(:ok, :message)

  describe '#add_attachment' do
    it 'adds an attachment to the cache of attachments' do
      slack = Slacker.new(@client)
      slack.add_attachment('foo', 'bar')
      expect(slack.instance_variable_get('@attachments')).to eq([
        {
          title: 'foo',
          value: 'bar'
        }
      ])
    end
  end

  describe '#send' do
    it 'returns if there are no attachments' do
      slack = Slacker.new(@client)
      expect(@client).to_not receive(:chat_postMessage)
      slack.send('hi')
    end

    it 'sends a message if there are attachments' do
      slack = Slacker.new(@client)
      slack.add_attachment('foo', 'bar')
      expect(@client).to receive(:chat_postMessage).with(
        channel: 'slack-test-channel',
        text: 'hi',
        attachments: [
          {
            fields: [
              {
                title: 'foo',
                value: 'bar'
              }
            ]
          }
        ],
        as_user: false,
        username: 'slack-test-username',
        icon_emoji: 'slack-test-icon-emoji'
      ).and_return(FakeResponse.new(true))
      slack.send('hi')
      expect(slack.instance_variable_get('@attachments')).to eq([])
    end
  end

  describe '#reactions' do
    it 'returns unless a timestamp is provided' do
      slack = Slacker.new(@client)
      expect(@client).to_not receive(:reactions_get)
      expect(slack.reactions(nil)).to eq(nil)
    end

    it 'calls the slack client' do
      slack = Slacker.new(@client)
      expect(@client).to receive(:reactions_get).with(
        channel: 'slack-test-channel',
        timestamp: '123'
      ).and_return(FakeResponse.new(true, ['emoji']))
      expect(slack.reactions('123')).to eq(['emoji'])
    end

    it 'returns nothing if the message was not found' do
      slack = Slacker.new(@client)
      expect(@client).to receive(:reactions_get).and_raise(Slack::Web::Api::Error, 'not found')
      expect(slack.reactions('123')).to eq([])
    end
  end
end
