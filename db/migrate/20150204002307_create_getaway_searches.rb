class CreateGetawaySearches < ActiveRecord::Migration
  def change
    create_table :getaway_searches do |t|
      t.decimal :price_limit
      t.references :user, index: true
      t.string :ip_address

      t.timestamps
    end
  end
end
