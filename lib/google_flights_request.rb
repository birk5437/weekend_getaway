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
    #doesnt workkk

   # https://www.google.com/flights/#search;f=SJC;t=EWR,JFK,LGA;d=2015-04-05;r=2015-04-12

    uri = URI.parse("https://www.google.com/flights/#search")

    params = {
      :f => @departure_airport,
      :t => @destination_airport,
      :d => @departure_date,
      :r => @return_date
    }

    headers = {
      # "Content-Type" => "application/json; charset=utf-8",
      "User-Agent" => "Mozilla/5.0 (Windows NT 6.3; rv:36.0) Gecko/20100101 Firefox/36.0"
    }

    request = Request.new(uri, :params => params, :use_ssl => true, :type => Request::GET)

    request.perform

  end

  def hack_request!
    #doesnt worrkkkkkk
    # TODO: get a real api
    res = `/Users/burke/google_flights_curl.sh`
    res2 = res.gsub("[,", "[")
  end

  def opx_request!
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

    params = {
      # "key" => "AIzaSyCqXbIkEF3_rYe6UWlxve1onhlVsVYFW4Y"
    }

    request = Request.new(uri, :headers => headers, :body => body, :params => params, :use_ssl => true, :type => Request::POST)
    request.perform
    # curl -d @request.json --header "Content-Type: application/json" https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyCqXbIkEF3_rYe6UWlxve1onhlVsVYFW4Y
  end
end
