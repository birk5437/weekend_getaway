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

   # https://www.google.com/flights/#search;f=SJC;t=EWR,JFK,LGA;d=2015-04-05;r=2015-04-12

    uri = URI.parse("https://www.google.com/flights/#search")

    params = {
      :f => @departure_airport,
      :t => @destination_airport,
      :d => @departure_date,
      :r => @return_date
    }

    headers = {
      "Content-Type" => "application/json; charset=utf-8"
    }

    request = Request.new(uri, :params => params, :use_ssl => true)

    request.perform

  end

end