class AddUploadsCountsCoulumnToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :uploads_count, :integer, default: 0, null: false

    reversible do |dir|
      dir.up { data }
    end
  end

  
  def data
  	execute <<-SQL.squish
	    UPDATE reviews
	       SET uploads_count = (SELECT count(1)
                              FROM uploads
                              WHERE uploads.imageable_id = reviews.id AND uploads.imageable_type = 'Review')
		SQL
  end
end
