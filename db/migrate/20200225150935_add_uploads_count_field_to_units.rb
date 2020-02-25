class AddUploadsCountFieldToUnits < ActiveRecord::Migration[5.0]
  def change
    add_column :units, :uploads_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  
  def data
  	execute <<-SQL.squish
	    UPDATE units
	       SET uploads_count = (SELECT count(1)
                              FROM uploads
                              WHERE uploads.imageable_id = units.id AND uploads.imageable_type = 'Unit')
		SQL
  end
end
