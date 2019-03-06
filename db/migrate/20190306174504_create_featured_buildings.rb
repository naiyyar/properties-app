class CreateFeaturedBuildings < ActiveRecord::Migration
  def change
    create_table :featured_buildings do |t|
      t.integer :building_id
      t.integer :featured_comp_id

      t.timestamps null: false
    end

    add_index :featured_buildings, [:building_id, :featured_comp_id]
  end
end
