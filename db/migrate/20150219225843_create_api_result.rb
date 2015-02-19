class CreateApiResult < ActiveRecord::Migration
  def change
    create_table :api_results do |t|
      t.references :getaway_search
      t.text :result_json
      t.timestamps
    end

    remove_column :getaway_searches, :api_result

  end
end
