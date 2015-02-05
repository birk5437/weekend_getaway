class AddFlyFromToGetawaySearches < ActiveRecord::Migration
  def change
    add_column :getaway_searches, :fly_from, :string
  end
end
