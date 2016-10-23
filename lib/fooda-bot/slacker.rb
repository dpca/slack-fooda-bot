class Slacker
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def send(message)
    response = client.chat_postMessage(
      channel: ENV['SLACK_CHANNEL'],
      text: message,
      as_user: false,
      username: ENV['SLACK_USERNAME'],
      icon_emoji: ENV['SLACK_ICON_EMOJI'],
    )
    response.ok ? response : nil
  end

  def reactions(timestamp)
    return nil unless timestamp
    response = client.reactions_get(
      channel: ENV['SLACK_CHANNEL'],
      timestamp: timestamp,
    )
    response.ok ? response.message : nil
  rescue Slack::Web::Api::Error
    # message not found
    []
  end
end
