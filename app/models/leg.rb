class Leg < ActiveRecord::Base
  belongs_to :segment

  def local_departure_time
    DateTime.parse(departure_time_stamp)
  end

  # def local_departure_time=(date_time)
  # end

  def local_arrival_time
    DateTime.parse(arrival_time_stamp)
  end

  # def local_arrival_time=(date_time)
  # end
end