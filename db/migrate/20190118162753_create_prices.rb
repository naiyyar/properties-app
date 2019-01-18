class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :priceable_id
      t.string :priceable_type
      t.decimal :min_price
      t.decimal :max_price
      t.integer :bed_type

      t.timestamps null: false
    end
  end
end
