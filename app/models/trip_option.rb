class TripOption < ActiveRecord::Base

  belongs_to :getaway_search
  has_many :segments, :dependent => :destroy
  has_many :legs, :through => :segments

end