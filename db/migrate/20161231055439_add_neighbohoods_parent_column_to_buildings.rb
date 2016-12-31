class AddNeighbohoodsParentColumnToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :neighborhoods_parent, :string
  end
end
