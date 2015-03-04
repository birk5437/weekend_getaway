class Leg < ActiveRecord::Base
  belongs_to :segment

  def local_departure_time
    departure_time.to_time.in_time_zone(ActiveSupport::TimeZone[self.departure_time_zone.split(":").first.to_i])
  end

  # def local_departure_time=(date_time)
  # end

  def local_arrival_time
    arrival_time.to_time.in_time_zone(ActiveSupport::TimeZone[self.arrival_time_zone.split(":").first.to_i])
  end

  # def local_arrival_time=(date_time)
  # end
end