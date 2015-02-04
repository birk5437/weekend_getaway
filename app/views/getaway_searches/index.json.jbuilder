json.array!(@getaway_searches) do |getaway_search|
  json.extract! getaway_search, :id, :price_limit, :user_id, :ip_address
  json.url getaway_search_url(getaway_search, format: :json)
end
