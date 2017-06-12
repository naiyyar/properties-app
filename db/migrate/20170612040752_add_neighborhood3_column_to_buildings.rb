class AddNeighborhood3ColumnToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :neighborhood3, :string
  end
end
