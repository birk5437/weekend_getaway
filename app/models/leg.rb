class Leg < ActiveRecord::Base
  belongs_to :segment

  def departure_time
    attributes["departure_time"].in_time_zone(ActiveSupport::TimeZone[self.departure_time_zone.split(":").first.to_i])
  end

  def departure_time=(date_time)
  end

  def arrival_time
  end

  def arrival_time=(date_time)
  end
end