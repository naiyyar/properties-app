class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
    	t.integer :building_id
    	t.string :name
    	t.text :pros
    	t.text :cons
    	t.integer :number_of_bedrooms
    	t.integer :number_of_bathrooms
    	t.decimal :monthly_rent, default: 0.0
    	t.decimal :square_feet, default: 0.0
    	t.decimal :total_upfront_cost, default: 0.0
    	t.date :rent_start_date
    	t.date :rent_end_date
    	t.decimal :security_deposit, default: 0.0
    	t.decimal :broker_fee, default: 0.0
    	t.decimal :move_in_fee, default: 0.0
    	t.decimal :rent_upfront_cost, default: 0.0
    	t.decimal :processing_fee, default: 0.0


      t.timestamps null: false
    end
  end

  def self.down
  	drop_table :units
  end
end
