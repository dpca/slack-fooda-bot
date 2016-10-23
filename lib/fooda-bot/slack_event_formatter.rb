class SlackEventFormatter
  attr_reader :event, :reactions

  def initialize(event, reactions)
    @event = event
    @reactions = reactions
  end

  def format
    if reactions
      "#{base}\n<#{reactions.permalink}|Last time> you thought #{formatted_reactions}"
    else
      base
    end
  end

  private

  def base
    "Hey there! Fooda is <#{event.url}|#{event.name}> (#{event.raw_date})"
  end

  def formatted_reactions
    reactions.reactions.map do |reaction|
      "#{reaction[:count]} :#{reaction[:name]}:"
    end.join(', ')
  end
end
