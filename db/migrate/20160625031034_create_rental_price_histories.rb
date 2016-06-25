class CreateRentalPriceHistories < ActiveRecord::Migration
  def change
    create_table :rental_price_histories do |t|
    	t.date :residence_start_date
    	t.date :residence_end_date
    	t.decimal :monthly_rent, default: 0.0
    	t.decimal :broker_fee, default: 0.0
    	t.decimal :non_refundable_costs, default: 0.0
    	t.decimal :rent_upfront, default: 0.0
    	t.decimal :refundable_deposits, default: 0.0
    	t.integer :unit_id

      t.timestamps null: false
    end
  end
end
