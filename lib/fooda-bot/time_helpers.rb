module TimeHelpers
  def self.today?(time)
    now = Time.new
    today_start = Time.new(now.year, now.month, now.day)
    today_end = today_start + 86399
    (today_start..today_end).cover?(time)
  end

  def self.tomorrow?(time)
    now = Time.new
    today_start = Time.new(now.year, now.month, now.day + 1)
    today_end = today_start + 86399
    (today_start..today_end).cover?(time)
  end
end
