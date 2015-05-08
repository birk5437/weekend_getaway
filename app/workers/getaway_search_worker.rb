class GetawaySearchWorker
  @queue = :long_running
  def self.perform(getaway_search_id)
    getaway_search = GetawaySearch.find(getaway_search_id)
    getaway_search.perform_search!
    getaway_search.search_complete = true
    getaway_search.save!
  end
end