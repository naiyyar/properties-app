class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
    	t.string  :stripe_customer_id
    	t.integer :user_id
      t.timestamps
    end
  end
end
