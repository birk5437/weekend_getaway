class GetawaySearch < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :fly_from, :price_limit
  # validates_formatting_of :ip_address, using: :ip_address_v4
  acts_as_votable

  def get_api_results!
    raise "Search is not valid!" unless self.valid?
    request = GoogleFlightsRequest.new(
  end
end
