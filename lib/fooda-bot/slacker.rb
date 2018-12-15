class Slacker
  attr_reader :client

  def initialize(client)
    @client = client
    @attachments = []
  end

  def add_attachment(title, message)
    @attachments << {
      title: title,
      value: message
    }
  end

  def send(message)
    return nil unless @attachments.any?
    response = client.chat_postMessage(
      channel: ENV['SLACK_CHANNEL'],
      text: message,
      attachments: formatted_attachments,
      as_user: false,
      username: ENV['SLACK_USERNAME'],
      icon_emoji: ENV['SLACK_ICON_EMOJI'],
    )
    @attachments = []
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

  private

  def formatted_attachments
    return nil unless @attachments.any?
    [
      {
        fields: @attachments
      }
    ]
  end
end
