class AddIndexToBuildingTable < ActiveRecord::Migration
  def change
  	add_index :buildings, :building_name
  	add_index :buildings, :building_street_address
  	add_index :buildings, :city
  	add_index :buildings, :zipcode
  end
end
