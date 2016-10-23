class Event
  attr_reader :connection

  def initialize(connection)
    @connection = connection
  end

  def to_s
    "#{name} #{date}\n#{url}"
  end

  def name
    page.search('.restaurant-banner__name').first.text.strip
  end

  def raw_date
    page.search('.secondary-bar__label').first.text.strip
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

  def page
    @_page ||= parse
  end

  private

  def parse
    Nokogiri::HTML(connection)
  end
end
