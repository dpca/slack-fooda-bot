class Peach
  def initialize(reaction_formatter)
    @time = Time.now
    @reaction_formatter = reaction_formatter
  end

  def restaurants
    results[:dishes].
      flat_map { |dish| dish[:restaurant] }.
      uniq { |restaurant| restaurant[:name] }.
      map do |restaurant|
        PeachRestaurant.new(restaurant, @reaction_formatter)
      end
  end

  def slack_format
    "#{restaurants.map(&:slack_format).join("\n")}#{sign_up_link}"
  end

  def title
    "<#{menu_url}|Peach> (order by 10:30)"
  end

  private

  def results
    @results ||= JSON.parse(RestClient.get(peach_url).body, symbolize_names: true)
  end

  def peach_url
    "https://www.peachd.com/orders/load_dishes_to_order/-1/#{home_location_id}/\?delivery_time\=#{@time.strftime('%Y-%m-%d')}+12:00:00\&features\=\{\}\&home_location_id\=#{home_location_id}\&menu_type\=lunch\&timezone\=US/Eastern"
  end

  def home_location_id
    ENV['PEACH_HOME_LOCATION_ID']
  end

  def peach_referral_code
    ENV['PEACH_REFERRAL_CODE']
  end

  def menu_url
    "https://www.peachd.com/menu/#{@time.strftime('%A')}/?location_id=#{home_location_id}"
  end

  def sign_up_link
    return '' unless peach_referral_code
    peach_referral_url = "https://www.peachd.com/refer/#{peach_referral_code}/"
    "\n<#{peach_referral_url}|Use this link to get your first lunch for $5>"
  end
end
