class Event
  attr_reader :connection

  def initialize(connection, slack, storage)
    @connection = connection
    @slack = slack
    @storage = storage
  end

  def restaurants
    page.search('.myfooda-event__restaurant').map do |search_result|
      Restaurant.new(search_result, @slack, @storage)
    end
  end

  def to_s
    "#{date}\n#{url}\n#{events.join("\n")}"
  end

  def page
    @_page ||= parse
  end

  def raw_date
    page.search('.cal__day--active').first.text.strip
  end

  def date
    Date.parse(raw_date.split(',').last.strip)
  end

  def today?
    TimeHelpers.today?(date.to_time)
  end

  def url
    connection.request.url
  end

  def slack_format
    "Hey there! Fooda today is:\n#{restaurants.map(&:slack_format).join("\n")}"
  end

  def save_as_latest
    storage.set_latest(restaurants.map(&:name))
  end

  private

  def parse
    Nokogiri::HTML(connection)
  end
end
