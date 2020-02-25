class AddUploadsCountFieldToBuildings < ActiveRecord::Migration[5.0]
  def change
    add_column :buildings, :uploads_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  
  def data
  	execute <<-SQL.squish
	    UPDATE buildings
	       SET uploads_count = (SELECT count(1)
                              FROM uploads
                              WHERE uploads.imageable_id = buildings.id AND uploads.imageable_type = 'Building')
		SQL
  end
end
