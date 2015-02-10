class TripOption < ActiveRecord::Base
  belongs_to :getaway_search
  has_many :segments, :dependent => :destroy

  serialize :segments_json, JSON
end