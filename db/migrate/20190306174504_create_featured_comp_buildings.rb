class CreateFeaturedCompBuildings < ActiveRecord::Migration
  def change
    create_table :featured_comp_buildings do |t|
      t.integer :building_id
      t.integer :featured_comp_id

      t.timestamps null: false
    end

    add_index :featured_comp_buildings, [:building_id, :featured_comp_id], :name => 'f_comp_buildings'
  end

end
