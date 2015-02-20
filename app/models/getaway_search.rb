class GetawaySearch < ActiveRecord::Base

  VALID_LEAVE_ON_VALUES = { a_friday: "A Friday", a_thursday: "A Thursday" }
  VALID_RETURN_ON_VALUES = { following_sunday: "The following Sunday", following_monday: "The following Monday" }

  belongs_to :user
  has_many :trip_options, :dependent => :destroy
  has_many :api_results, :dependent => :destroy

  validates_presence_of :fly_from, :price_limit
  validates_inclusion_of :leave_on, :in => VALID_LEAVE_ON_VALUES.keys.map(&:to_s)
  validates_inclusion_of :return_on, :in => VALID_RETURN_ON_VALUES.keys.map(&:to_s)
  # validates_formatting_of :ip_address, using: :ip_address_v4

  after_create :download_api_results!

  acts_as_votable

  def get_api_result(param_options={})
    raise "Search is not valid!" unless self.valid?
    request = GoogleFlightsRequest.new(
      :max_price => '%.02f' % param_options[:price_limit],
      :departure_airport => param_options[:fly_from],
      :destination_airport => "ATL",
      :departure_date => param_options[:departure_date],#DateTime.now + 5.weeks,
      :return_date => param_options[:return_date]#DateTime.now + 5.weeks + 3.days
    )

    response = request.make_request!
    api_res = ApiResult.new(result_json: JSON.parse(response.body))
    self.api_results << api_res
  end

  def add_trip_options!
    api_results.each do |res|
      adapter = GoogleFlightsAdapter.new(res)
      adapter.trip_options.each do |trip_option|
        self.trip_options << trip_option if trip_option.price < price_limit + 10.0
      end
      # save!
    end
  end

  def earliest_departure_date
    Chronic.parse("next #{leave_on.gsub('a_', '')}")
  end

  private ############################################################################################################################

  def download_api_results!


    [earliest_departure_date, earliest_departure_date + 7.days, earliest_departure_date + 14.days].each do |possible_departure_date|
      get_api_result(
        price_limit: price_limit,
        fly_from: fly_from,
        departure_date: possible_departure_date,
        return_date: possible_departure_date + 2.days
      )
    end

    add_trip_options!
  end

  def get_first_departure_date
    Chronic.parse("next #{leave_on.gsub('a_', '')}") + 7.hours
  end

end
