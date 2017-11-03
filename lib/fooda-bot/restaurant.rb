class Restaurant
  attr_reader :name, :url

  def initialize(unparsed_result, slack, storage)
    @name = unparsed_result.search('.myfooda-event__name').first.text.strip
    @url = unparsed_result['href']
    @slack = slack
    @storage = storage
  end

  def to_s
    "#{name}: #{url}"
  end

  def slack_format
    "<#{url}|#{name}>: #{formatted_reactions}"
  end

  def chicken_and_rice_guys?
    name.casecmp('chicken and rice guys').zero?
  end

  private

  def reactions
    @_reactions ||= @slack.reactions(@storage.lookup(name))
  end

  def formatted_reactions
    if reactions
      reactions.map { |reaction| "#{reaciton[:count]} :#{reaction[:name]}:" }.join(' ')
    else
      'No reactions!'
    end
  end
end
