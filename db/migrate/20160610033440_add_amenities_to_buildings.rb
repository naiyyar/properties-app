class AddAmenitiesToBuildings < ActiveRecord::Migration
  def self.up
  	add_column :buildings,  :pets_allowed, :boolean
    add_column :buildings,  :laundry_facility, :boolean
    add_column :buildings,  :parking, :boolean
    add_column :buildings,  :doorman, :boolean
    add_column :buildings,  :elevator, :boolean
    add_column :buildings,  :description, :text
  end
  def self.down
  	remove_column :buildings,  :pets_allowed, :boolean
    remove_column :buildings,  :laundry_facility, :boolean
    remove_column :buildings,  :parking, :boolean
    remove_column :buildings,  :doorman, :boolean
    remove_column :buildings,  :elevator, :boolean
  end
end
