class GetawaySearch < ActiveRecord::Base
  belongs_to :user
  has_many :trip_options, :dependent => :destroy

  validates_presence_of :fly_from, :price_limit
  serialize :api_result, JSON
  # validates_formatting_of :ip_address, using: :ip_address_v4

  after_create :download_api_results!

  acts_as_votable

  def get_api_results!
    raise "Search is not valid!" unless self.valid?
    request = GoogleFlightsRequest.new(
      :max_price => '%.02f' % price_limit,
      :departure_airport => fly_from,
      :destination_airport => "ATL",
      :departure_date => DateTime.now + 5.weeks,
      :return_date => DateTime.now + 5.weeks + 3.days)

    response = request.make_request!
    self.api_result = JSON.parse(response.body)
    self.api_result_updated_at = DateTime.now
    save!
  end

  def create_trip_options!
    adapter = GoogleFlightsAdapter.new(self)
    self.trip_options = adapter.trip_options
    save!
  end


  private ############################################################################################################################

  def download_api_results!
    get_api_results!
    create_trip_options!
  end
end
