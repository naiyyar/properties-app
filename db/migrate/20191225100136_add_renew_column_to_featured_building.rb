class AddRenewColumnToFeaturedBuilding < ActiveRecord::Migration[5.0]
  def change
    add_column :featured_buildings, :renew, :boolean, default: false
  end
end
