class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.decimal :min_price
      t.decimal :max_price
      t.integer :bed_type
      t.integer :range

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :prices
  end
end
