module DateFormatChecking
  extend ActiveSupport::Concern

  DATE_FMT = "%Y-%m-%d"


  def ensure_valid_date!(datestring)
    unless DateFormatChecking.valid_date? datestring
      raise ArgumentError.new "Invalid date: #{datestring}"
    end
  end

  def ensure_valid_dates!(*datestrings)
    datestrings.each {|d| ensure_valid_date! d}
  end

  def self.valid_date?(datestring)
    return false unless datestring.match? /\A\d{4}-\d{2}-\d{2}\z/
    begin Date.parse(datestring) rescue false end
    true
  end

  def self.valid_dates?(*datestrings)
    return datestrings.all? {|d| valid_date? d}
  end
end
