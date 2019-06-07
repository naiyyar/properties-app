class CreateRentMedians < ActiveRecord::Migration
  def change
    create_table :rent_medians do |t|
    	t.decimal :price
      t.integer :bed_type
      t.integer :range
      t.timestamps null: false
    end
  end
end
