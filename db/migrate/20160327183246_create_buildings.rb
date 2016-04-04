class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :building_name
      t.string :building_street_address

      t.timestamps null: false
    end
  end
end
