class AddNeighborhoodColumnToGcoordinates < ActiveRecord::Migration
  def change
  	add_column :gcoordinates, :neighborhood, :string
  end
end
