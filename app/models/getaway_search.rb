class GetawaySearch < ActiveRecord::Base

  DESTINATIONS = ["ATL","ORD","DEN","SFO","LAX","SEA","MIA","MSO"]

  VALID_LEAVE_ON_VALUES = { a_friday: "A Friday", a_thursday: "A Thursday" }
  VALID_RETURN_ON_VALUES = { following_sunday: "The following Sunday", following_monday: "The following Monday" }

  belongs_to :user
  has_many :trip_options, :dependent => :destroy
  has_many :api_results, :dependent => :destroy

  validates_presence_of :fly_from, :price_limit, :leave_on, :return_on
  # validates_inclusion_of :leave_on, :in => VALID_LEAVE_ON_VALUES.keys.map(&:to_s)
  # validates_inclusion_of :return_on, :in => VALID_RETURN_ON_VALUES.keys.map(&:to_s)
  # validates_formatting_of :ip_address, using: :ip_address_v4


  acts_as_votable

  def get_api_result(param_options={})

    fly_to = param_options[:fly_to]
    fly_from = param_options[:fly_from]

    raise "Search is not valid!" unless self.valid? && fly_from.present? && fly_to.present? && DESTINATIONS.include?(fly_to) && fly_from != fly_to

    key = "#{fly_from}_to_#{fly_to}_on_#{param_options[:departure_date].strftime("%m_%d_%Y")}_return_#{param_options[:return_date].strftime("%m_%d_%Y")}"
    begin
      response_body = DbCacheItem.get(key, valid_for: 365.days) do
        request = GoogleFlightsRequest.new(
          :max_price => "1000.00",#'%.02f' % param_options[:price_limit],
          :departure_airport => fly_from,
          :destination_airport => fly_to,
          :departure_date => param_options[:departure_date],#DateTime.now + 5.weeks,
          :return_date => param_options[:return_date]#DateTime.now + 5.weeks + 3.days
        )
        response = request.make_request!
        response.body
      end
    rescue Exception
      response_body = nil
    end

    if response_body.present?
      api_res = ApiResult.new(result_json: JSON.parse(response_body),
                  fly_from: fly_from,
                  fly_to: fly_to
                )
      self.api_results << api_res
    end
  end

  def add_trip_options!
    real_price_limit = price_limit + 10.0
    api_results.each do |res|
      adapter = GoogleFlightsAdapter.new(res)
      adapter.trip_options.each do |trip_option|
        if trip_option.price <= real_price_limit
          self.trip_options << trip_option
        else
          trip_option.destroy
        end

      end
    end
  end

  def earliest_departure_date
    Chronic.parse("next #{leave_on.gsub('a_', '')}")
  end

  def cheapest_trip_option
    trip_options.sort_by(&:price).first
  end

  def perform_search!


    [
      # earliest_departure_date,
      earliest_departure_date + 7.days#,
      # earliest_departure_date + 14.days
      # earliest_departure_date + 21.days  # TODO: move into worker to do longer searches
    ].each do |possible_departure_date|
      (DESTINATIONS - [fly_from]).each do |destination|
        get_api_result(
          price_limit: price_limit,
          fly_from: fly_from,
          fly_to: destination,
          departure_date: possible_departure_date,
          return_date: possible_departure_date + 2.days
        )
      end
    end

    add_trip_options!
  end

  private ############################################################################################################################



  def get_first_departure_date
    Chronic.parse("next #{leave_on.gsub('a_', '')}") + 7.hours
  end

end
