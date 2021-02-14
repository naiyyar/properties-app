class AddNeighborhoodFieldToFeaturedListings < ActiveRecord::Migration[5.0]
  def change
    add_column :featured_listings, :neighborhood1, :string, index: true
  end
end
