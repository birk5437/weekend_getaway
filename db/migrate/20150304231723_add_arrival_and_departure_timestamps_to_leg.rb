class AddArrivalAndDepartureTimestampsToLeg < ActiveRecord::Migration
  def change
    add_column :legs, :departure_time_stamp, :string
    add_column :legs, :arrival_time_stamp, :string
  end
end
