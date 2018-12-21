class PeachRestaurant
  attr_reader :name

  def initialize(restaurant, reaction_formatter)
    @restaurant = restaurant
    @reaction_formatter = reaction_formatter
  end

  def name
    @restaurant[:display_name]
  end

  def to_s
    name
  end

  def slack_format
    "#{name}: #{@reaction_formatter.reactions(name)}"
  end
end
