class CreateFeaturedComps < ActiveRecord::Migration
  def change
    create_table :featured_comps do |t|
    	t.integer :building_id, null: false
    	t.date :start_date
    	t.date :end_date
      t.boolean :active, default: false
      
      t.timestamps null: false
    end
    add_index :featured_comps, [:start_date, :end_date]
    add_index :featured_comps, :active
  end
end
