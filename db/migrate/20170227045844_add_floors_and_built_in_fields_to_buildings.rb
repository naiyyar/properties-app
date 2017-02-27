class AddFloorsAndBuiltInFieldsToBuildings < ActiveRecord::Migration
  def change
  	add_column :buildings, :floors, :integer
  	add_column :buildings, :built_in, :integer
  end
end
