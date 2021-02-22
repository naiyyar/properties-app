class AddAmenitiesToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings,  :laundry_facility, :boolean, default: false
    add_column :buildings,  :parking, :boolean, default: false
    add_column :buildings,  :doorman, :boolean, default: false
    add_column :buildings,  :description, :text
  end
end
