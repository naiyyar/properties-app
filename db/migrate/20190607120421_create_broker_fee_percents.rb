class CreateBrokerFeePercents < ActiveRecord::Migration
  def change
    create_table :broker_fee_percents do |t|
    	t.integer :percent_amount, default: 0
      t.timestamps null: false
    end
  end
end
