class AddFlyToAndFlyFromToApiResults < ActiveRecord::Migration
  def change
    add_column :api_results, :fly_from, :string
    add_column :api_results, :fly_to, :string
  end
end
