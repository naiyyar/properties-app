class AddNumberOfUnitsFieldsToBuildings < ActiveRecord::Migration
  def change
  	add_column :buildings, :number_of_units, :integer
  end
end
