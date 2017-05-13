class ChangeBathroomsColumnType < ActiveRecord::Migration
  def change
  	change_column :units, :number_of_bathrooms, :decimal, :default => 0.0
  end
end
