class ReactionFormatter
  def initialize(slack, storage)
    @slack = slack
    @storage = storage
    @_reactions = {}
  end

  def reactions(name)
    slack_reactions = fetch_reactions(name)
    if slack_reactions
      if slack_reactions.reactions&.any?
        slack_reactions.reactions.map do |reaction|
          "#{reaction[:count]} :#{reaction[:name]}:"
        end.join(' ') + " (#{reactions_link(slack_reactions)})"
      else
        "No reactions! (#{reactions_link(slack_reactions)})"
      end
    else
      'No previous event found'
    end
  end

  private

  def fetch_reactions(name)
    @_reactions[name] ||= @slack.reactions(@storage.lookup(name))
  end

  def reactions_link(slack_reactions)
    "<#{slack_reactions.permalink}|jump>"
  end
end
