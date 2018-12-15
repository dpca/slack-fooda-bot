class Restaurant
  attr_reader :name, :url, :location

  def initialize(unparsed_result, slack, storage)
    @name = unparsed_result.search('.myfooda-event__name').first.text.strip
    @url = unparsed_result['href']
    @location = unparsed_result.search('.myfooda-vendor-location-name').first.text.strip
    @slack = slack
    @storage = storage
  end

  def to_s
    "#{name}: #{url}"
  end

  def slack_format
    "<#{url}|#{name}> @ #{location}: #{formatted_reactions}"
  end

  private

  def reactions
    @_reactions ||= @slack.reactions(@storage.lookup(name))
  end

  def reactions_link
    "<#{reactions.permalink}|jump>"
  end

  def formatted_reactions
    if reactions
      if reactions.reactions&.any?
        reactions.reactions.map do |reaction|
          "#{reaction[:count]} :#{reaction[:name]}:"
        end.join(' ') + " (#{reactions_link})"
      else
        "No reactions! (#{reactions_link})"
      end
    else
      'No previous event found'
    end
  end
end
