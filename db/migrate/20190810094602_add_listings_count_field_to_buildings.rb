class AddListingsCountFieldToBuildings < ActiveRecord::Migration[5.0]
  def change
    add_column :buildings, :listings_count, :integer, default: 0, null: false, index: true
    
    reversible do |dir|
	    dir.up { data }
	  end
  end

  def data
  	execute <<-SQL.squish
	    UPDATE buildings
	       SET listings_count = (SELECT count(1)
                              FROM listings
                              WHERE listings.building_id = buildings.id AND listings.active = true)
		SQL
  end
end
