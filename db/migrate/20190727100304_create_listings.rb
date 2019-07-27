class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
    	t.integer :building_id
    	t.string :building_address
    	t.string :management_company
    	t.string :unit
    	t.integer :rent
    	t.integer :bed
    	t.decimal :bath
    	t.decimal :free_months
    	t.decimal :owner_paid
    	t.date :date_active
    	t.date :date_available
    	t.boolean :rent_stabilize, default: false
    	t.boolean :active, default: true
      t.timestamps
    end
  end
end
