class GoogleFlightsAdapter


# s = GetawaySearch.last
# res = GoogleFlightsAdapter.parse_trip_option(s.trip_options.first)

def self.parse_trip_option(json)
  hsh = {}
  hsh[:price] = json["saleTotal"]
  hsh[:departure_time] = json["slice"][0]["segment"][0]["leg"][0]["departureTime"]
  hsh
end


end