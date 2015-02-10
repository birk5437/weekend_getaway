class TripOption < ActiveRecord::Base

  belongs_to :getaway_search
  has_many :segments, :dependent => :destroy
  has_many :legs, :through => :segments

  def destination_leg
    previous_leg = nil
    legs.each do |l|
      if previous_leg.present? && previous_leg.destination == l.origin && previous_leg.segment.married_segment_group != l.segment.married_segment_group
        return previous_leg
        break
      else
        previous_leg = l
      end
    end
  end

  def first_origin
    return nil unless legs.present?
    legs.first.origin
  end

  def final_destination
    destination_leg.destination
  end

  def leave_at
    legs.first.try(:departure_time)
  end

  def return_at
    legs.last.try(:arrival_time)
  end

  def outbound_legs
    segments.where(:married_segment_group => legs.first.segment.married_segment_group).map(&:legs).flatten
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
    segments.where(:married_segment_group => legs.last.segment.married_segment_group).map(&:legs).flatten
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