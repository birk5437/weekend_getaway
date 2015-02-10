class GoogleFlightsAdapter


  # s = GetawaySearch.last
  # res = GoogleFlightsAdapter.parse_trip_option(s.trip_options.first)

  attr_accessor :getaway_search


  def initialize(getaway_search)
    @getaway_search = getaway_search
  end

  def trip_options
    trip_options_json.map do |j|
      @getaway_search.trip_options.build(parse_trip_option(j))
    end
  end

  def trip_options_json
    return [] unless @getaway_search.api_result.present?
    @getaway_search.api_result["trips"]["tripOption"]
  end

  def parse_trip_option(trip_option_json)
    hsh = {}
    hsh[:price] = trip_option_json["saleTotal"].gsub("USD", "").to_d
    hsh[:qpx_id] = trip_option_json["id"]
    segments_json = trip_option_json["slice"].map{ |slice| slice["segment"] }.flatten
    hsh[:segments] = segments_json.map { |j| Segment.new(parse_segment(j)) }
    # hsh[:departure_time] = @getaway_search.api_result["slice"][0]["segment"][0]["leg"][0]["departureTime"]
    hsh
  end

  def parse_segment(segment_json)
    Rails::logger.warn("SEGMENT_JSON - #{segment_json}")
    hsh = {}
    hsh[:qpx_id] = segment_json["id"]
    hsh[:flight_carrier] = segment_json["flight"]["carrier"]
    hsh[:flight_number] = segment_json["flight"]["number"]
    hsh[:cabin] = segment_json["cabin"]
    legs_json = segment_json["leg"]
    hsh[:legs] = legs_json.map{ |j| Leg.new(parse_leg(j)) }
    hsh
  end

  def parse_leg(leg_json)
    hsh = {}
    hsh[:qpx_id] = leg_json["id"]
    hsh[:aircraft] = leg_json["aircraft"]
    hsh[:origin] = leg_json["origin"]
    hsh[:departure_time] = DateTime.parse(leg_json["departureTime"])
    hsh[:destination] = leg_json["destination"]
    hsh[:arrival_time] = DateTime.parse(leg_json["arrivalTime"])
    hsh[:on_time_performance] = leg_json["onTimePerformance"]
    hsh[:mileage] = leg_json["mileage"]
    hsh[:duration] = leg_json["duration"]
    hsh
  end

end