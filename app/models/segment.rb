class Segment < ActiveRecord::Base
  belongs_to :trip_option
  has_many :legs, :dependent => :destroy
end