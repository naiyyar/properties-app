class AddPlayroomAndNoFeeAmenitiesFieldToBuildings < ActiveRecord::Migration
  def self.up
  	add_column :buildings, :childrens_playroom, :boolean, default: false
  	add_column :buildings, :no_fee, 						:boolean, default: false
  end

  def self.down
  	remove_column :buildings, :childrens_playroom
  	remove_column :buildings, :no_fee
  end
end
