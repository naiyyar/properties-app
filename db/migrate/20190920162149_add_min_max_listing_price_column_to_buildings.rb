class AddMinMaxListingPriceColumnToBuildings < ActiveRecord::Migration[5.0]
  def change
    add_column :buildings, :min_listing_price, :integer
    add_column :buildings, :max_listing_price, :integer
  end
end
