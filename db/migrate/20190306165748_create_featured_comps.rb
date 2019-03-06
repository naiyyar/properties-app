class CreateFeaturedComps < ActiveRecord::Migration
  def change
    create_table :featured_comps do |t|
    	t.string :comp_id, null: false
    	t.integer :building_id, null: false
    	t.datetime :start_date
    	t.datetime :end_date
      t.boolean :active, default: false
      
      t.timestamps null: false
    end
    add_index :featured_comps, [:comp_id, :building_id], unique: true
    add_index :featured_comps, :start_date
    add_index :featured_comps, :end_date
  end
end
