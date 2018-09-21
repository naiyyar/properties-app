class AddBedroomFieldsToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :studio, :integer
    add_column :buildings, :one_bed, :integer
    add_column :buildings, :two_bed, :integer
    add_column :buildings, :three_bed, :integer
    add_column :buildings, :four_plus_bed, :integer
    add_column :buildings, :price, :integer
  end
end
