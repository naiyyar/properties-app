class AddStatusColumnToFeaturedBuildings < ActiveRecord::Migration[5.0]
  def change
    add_column :featured_buildings, :status, :integer
    add_index  :featured_buildings, :status
  end
end
