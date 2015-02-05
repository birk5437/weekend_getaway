class AddApiResultToGetawaySearches < ActiveRecord::Migration
  def change
    add_column :getaway_searches, :api_result, :text
    add_column :getaway_searches, :api_result_updated_at, :datetime
  end
end
