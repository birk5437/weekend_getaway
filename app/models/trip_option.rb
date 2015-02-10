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

end