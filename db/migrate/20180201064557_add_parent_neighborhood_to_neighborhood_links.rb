class AddParentNeighborhoodToNeighborhoodLinks < ActiveRecord::Migration
  def change
    add_column :neighborhood_links, :parent_neighborhood, :string
  end
end
