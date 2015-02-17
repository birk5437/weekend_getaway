class AddFlyToToTripOptions < ActiveRecord::Migration
  def change
    add_column :trip_options, :fly_to, :string
  end
end
