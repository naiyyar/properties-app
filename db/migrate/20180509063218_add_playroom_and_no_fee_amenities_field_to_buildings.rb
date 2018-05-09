class AddPlayroomAndNoFeeAmenitiesFieldToBuildings < ActiveRecord::Migration
  def change
  	add_column :buildings, :childrens_playroom, :boolean, default: false
  	add_column :buildings, :no_fee, 						:boolean, default: false
  end
end
