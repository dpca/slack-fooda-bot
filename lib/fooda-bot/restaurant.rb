class Restaurant
  attr_reader :name, :url, :location

  def initialize(unparsed_result, reaction_formatter)
    @name = unparsed_result.search('.myfooda-event__name').first.text.strip
    @url = unparsed_result['href']
    @location = unparsed_result.search('.myfooda-vendor-location-name').first.text.strip
    @reaction_formatter = reaction_formatter
  end

  def to_s
    "#{name}: #{url}"
  end

  def slack_format
    "<#{url}|#{name}> @ #{location}: #{@reaction_formatter.reactions(name)}"
  end
end
