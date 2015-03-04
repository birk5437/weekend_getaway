class AddTimeZoneToLegs < ActiveRecord::Migration
  def change
    add_column :legs, :departure_time_zone, :string
    add_column :legs, :arrival_time_zone, :string
  end
end
