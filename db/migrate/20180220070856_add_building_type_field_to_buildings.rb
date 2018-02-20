class AddBuildingTypeFieldToBuildings < ActiveRecord::Migration
  def self.up
    add_column :buildings, :building_type, :string
  end

  def self.down
    remove_column :buildings, :builting_type
  end
end
