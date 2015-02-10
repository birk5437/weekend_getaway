class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :qpx_id
      t.string :flight_carrier
      t.string :flight_number
      t.string :cabin
      t.string :married_segment_group
      t.references :trip_option
      t.timestamps
    end
  end
end
