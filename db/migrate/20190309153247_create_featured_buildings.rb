class CreateFeaturedBuildings < ActiveRecord::Migration
  def change
    create_table :featured_buildings do |t|
    	t.integer :building_id, null: false
    	t.date :start_date
    	t.date :end_date
      t.boolean :active, default: false
      t.timestamps null: false
    end
  end
end
