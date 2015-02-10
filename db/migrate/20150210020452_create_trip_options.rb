class CreateTripOptions < ActiveRecord::Migration
  def change
    create_table :trip_options do |t|
      t.decimal :price
      t.string :qpx_id
      t.text :segments_json
      t.references :getaway_search
      t.timestamps
    end
  end
end
