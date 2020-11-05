class Slacker
  attr_reader :client

  def initialize(client)
    @client = client
    @_attachments = []
  end

  def add_attachment(title, message)
    @_attachments << {
      title: title,
      text: message
    }
  end

  def send_with_attachments(message)
    response = if @_attachments.any?
                 post_message(message, @_attachments)
               else
                 post_message("Oh no! I didn't find any lunch options :sadparrot:")
                 nil
               end
    @_attachments = []
    response
  end

  def send(message)
    post_message(message)
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

  def post_message(message, attachments = [])
    response = client.chat_postMessage(
      channel: ENV['SLACK_CHANNEL'],
      text: message,
      attachments: attachments,
      as_user: false,
      username: ENV['SLACK_USERNAME'],
      icon_emoji: ENV['SLACK_ICON_EMOJI'],
    )
    response.ok ? response : nil
  end
end
