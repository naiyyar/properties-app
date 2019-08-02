class AddReviewCountColumnToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :reviews_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  
  def data
  	execute <<-SQL.squish
	    UPDATE buildings
	       SET reviews_count = (SELECT count(1)
                              FROM reviews
                              WHERE reviews.reviewable_id = buildings.id AND reviews.reviewable_type = 'Building')
		SQL
  end
end
