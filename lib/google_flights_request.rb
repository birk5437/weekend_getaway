class GoogleFlightsRequest

  attr_accessor :departure_airport
  attr_accessor :destination_airport
  attr_accessor :departure_date
  attr_accessor :return_date

  def initialize(options={})
    @max_price = options[:max_price]
    @departure_airport = options[:departure_airport]
    @destination_airport = options[:destination_airport]
    @departure_date = options[:departure_date]
    @return_date = options[:return_date]
    @return_date = @return_date.strftime("%Y-%m-%d") if @return_date.present?
    @departure_date = @departure_date.strftime("%Y-%m-%d") if @departure_date.present?
  end

  # req = GoogleFlightsRequest.new(:max_price => "200.00", :destination_airport => "ATL", :departure_airport => "IND", :departure_date => DateTime.now + 5.weeks, :return_date => DateTime.now + 5.weeks + 3.days)

  def make_request!
    # AIzaSyCqXbIkEF3_rYe6UWlxve1onhlVsVYFW4Y

    uri = URI.parse("https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyCqXbIkEF3_rYe6UWlxve1onhlVsVYFW4Y")

    body = {
      "request": {
        "passengers": {
          "adultCount": 1
        },
        "slice": [
          {
            "origin": @departure_airport,
            "destination": @destination_airport,
            "date": @departure_date
          },
          {
            "origin": @destination_airport,
            "destination": @departure_airport,
            "date": @return_date
          }
        ]
      }
    }

    if @max_price.present?
      body["maxPrice"] = "USD#{@max_price}"
    end

    body = body.to_json
    raise body.inspect

    headers = {
      "Content-Type" => "application/json"
    }

    request = Request.new(uri, :headers => headers, :body => body, :use_ssl => true, :type => Request::POST)
    request.perform
  end
end
