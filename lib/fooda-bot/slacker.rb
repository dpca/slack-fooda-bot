class Slacker
  attr_reader :client

  def initialize(client)
    @client = client
    @attachments = []
  end

  def add_attachment(title, message)
    @attachments << {
      title: title,
      text: message
    }
  end

  def send(message)
    response = if @attachments.any?
                 post_message(message)
               else
                 post_message("Oh no! I didn't find any lunch options :sadparrot:")
                 nil
               end
    @attachments = []
    response
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
    nil
  end

  private

  def post_message(message)
    response = client.chat_postMessage(
      channel: ENV['SLACK_CHANNEL'],
      text: message,
      attachments: @attachments,
      as_user: false,
      username: ENV['SLACK_USERNAME'],
      icon_emoji: ENV['SLACK_ICON_EMOJI'],
    )
    response.ok ? response : nil
  end
end
