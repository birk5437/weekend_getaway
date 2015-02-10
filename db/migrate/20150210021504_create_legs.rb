class CreateLegs < ActiveRecord::Migration
  def change
    create_table :legs do |t|
      t.string :qpx_id
      t.string :aircraft
      t.datetime :departure_time
      t.datetime :arrival_time
      t.string :origin
      t.string :destination
      t.string :operating_disclosure
      t.integer :on_time_performance
      t.integer :mileage
      t.integer :duration_in_mintues
      t.references :segment
      t.timestamps
    end
  end
end
