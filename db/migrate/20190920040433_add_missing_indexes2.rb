class AddMissingIndexes2 < ActiveRecord::Migration[5.0]
  def change
  	add_index :listings, [:building_id, :building_address]
  end
end
