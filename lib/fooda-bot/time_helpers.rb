module TimeHelpers
  def self.today?(time)
    now = Time.new
    today_start = Time.new(now.year, now.month, now.day)
    today_end = today_start + 86399
    (today_start..today_end).cover?(time)
  end

  def self.tomorrow?(time)
    now = Time.new
    tomorrow_start = Time.new(now.year, now.month, now.day) + 86400
    tomorrow_end = tomorrow_start + 86399
    (tomorrow_start..tomorrow_end).cover?(time)
  end
end
