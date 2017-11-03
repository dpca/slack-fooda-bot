class SlackEventFormatter
  attr_reader :event, :reactions

  def initialize(event, reactions)
    @event = event
    @reactions = reactions
  end

  def format
    if reactions
      "#{base}\n<#{reactions.permalink}|Last time> you reacted with: #{formatted_reactions}"
    else
      base
    end
  end

  private

  def base
    "Hey there! Fooda today (#{event.raw_date}) is:\n#{event.map(&:slack_link).join("\n")}"
  end

  def formatted_reactions
    if reactions.reactions
      reactions.reactions.map do |reaction|
        "#{reaction[:count]} :#{reaction[:name]}:"
      end.join(' ')
    else
      'no reactions??? Bad humans!'
    end
  end
end
