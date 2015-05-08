class GetawaySearchDestroyWorker
  @queue = :long_running
  def self.perform(getaway_search_id)
    getaway_search = GetawaySearch.find(getaway_search_id)
    getaway_search.destroy
  end
end