class AddUserIdAndFeaturedByFieldsToFeaturedBuildings < ActiveRecord::Migration[5.0]
  def change
    add_column :featured_buildings, :user_id, :integer
    add_column :featured_buildings, :featured_by, :string, default: 'admin'
  end
end
