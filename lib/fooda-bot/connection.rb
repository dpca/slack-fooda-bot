class Connection
  attr_reader :fooda_url

  def initialize(fooda_url)
    @fooda_url = fooda_url
  end

  def call
    @result ||= make_call
  end

  def url
    @last_result.request&.url
  end

  private

  def make_call
    result = parsed_call(@fooda_url)

    # If fooda redirected us to the individual popup page, follow the calendar
    # link to get back to the overview. This lets us use the same parsing
    # methods regardless of whether they have one or many popups.
    calendar_link = result.search('.myfooda-link')
    if calendar_link.any?
      return parsed_call("app.fooda.com#{calendar_link.first[:href].strip}")
    end

    result
  end

  def parsed_call(url)
    Nokogiri::HTML(fetch(url))
  end

  def fetch(url)
    RestClient.get(url, cookies: @cookies).tap do |result|
      @last_result = result
      # Set cookies to use the session that fooda returns
      @cookies = result.cookies
    end
  end
end
