class TripOption < ActiveRecord::Base

  belongs_to :getaway_search
  has_many :segments, :dependent => :destroy
  has_many :legs, :through => :segments

  delegate :fly_from, to: :getaway_search

  validates_presence_of :fly_to

  def destination_leg
    legs.where(destination: fly_to).limit(1).first
  end

  def first_origin
    return nil unless legs.present?
    legs.first.origin
  end

  def leave_at
    legs.first.try(:local_departure_time)
  end

  def return_at
    legs.last.try(:local_arrival_time)
  end

  def outbound_legs
    legs.take_while{ |leg| leg.origin != fly_to }
  end

  def outbound_itinerary
    previous_airport_code = nil

    chunk_result = outbound_legs.map { |leg| [leg.origin, leg.destination]}.flatten.chunk do |airport_code|
      return_value = (airport_code == previous_airport_code)
      previous_airport_code = airport_code
      return_value
    end
    chunk_result.select{ |bool, codes| bool == false }.map(&:last).flatten
  end

  def inbound_legs
    legs - outbound_legs
  end

  def inbound_itinerary
    previous_airport_code = nil

    chunk_result = inbound_legs.map { |leg| [leg.origin, leg.destination]}.flatten.chunk do |airport_code|
      return_value = (airport_code == previous_airport_code)
      previous_airport_code = airport_code
      return_value
    end
    chunk_result.select{ |bool, codes| bool == false }.map(&:last).flatten
  end

end