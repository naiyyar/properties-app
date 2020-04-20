class AddFeaturedBuildingsCountToBuildings < ActiveRecord::Migration[5.0]
  def change
    add_column :buildings, :featured_buildings_count, :integer
  end
end
