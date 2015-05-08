class AddSearchCompleteToGetawaySearches < ActiveRecord::Migration
  def change
    add_column :getaway_searches, :search_complete, :boolean, null: false, default: false
  end
end
