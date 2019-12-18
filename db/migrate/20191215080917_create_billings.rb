class CreateBillings < ActiveRecord::Migration[5.0]
  def change
    create_table :billings do |t|
    	t.integer :user_id
    	t.integer :featured_building_id
    	t.decimal :amount, 							default: 0.0
    	t.string 	:status
    	t.string :stripe_customer_id, 	unique: true
      t.string :stripe_card_id,       unique: true
      t.string :stripe_charge_id,     unique: true
      t.timestamps
    end
  end
end
