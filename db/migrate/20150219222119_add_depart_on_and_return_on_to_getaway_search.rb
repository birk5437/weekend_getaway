class AddDepartOnAndReturnOnToGetawaySearch < ActiveRecord::Migration
  def change
    add_column :getaway_searches, :leave_on, :string
    add_column :getaway_searches, :leave_on_time_of_day, :string
    add_column :getaway_searches, :return_on, :string
    add_column :getaway_searches, :return_on_time_of_day, :string
  end
end
