class GoogleFlightsRequest

  attr_accessor :departure_airport
  attr_accessor :destination_airport
  attr_accessor :departure_date
  attr_accessor :return_date

  def initialize(departure_airport, destination_airport, departure_date, return_date)
    @departure_airport = departure_airport
    @destination_airport = destination_airport
    @departure_date = departure_date.strftime("%Y-%m-%d")
    @return_date = return_date.strftime("%Y-%m-%d")
  end

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
    }.to_json

    headers = {
      "Content-Type" => "application/json"
    }

    request = Request.new(uri, :headers => headers, :body => body, :use_ssl => true, :type => Request::POST)
    request.perform
  end
end
