class AddReviewsCountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :reviews_count, :integer, default: 0, null: false
	  
	  reversible do |dir|
	    dir.up { data }
	  end
  end

  
  def data
  	execute <<-SQL.squish
	    UPDATE users
	       SET reviews_count = (SELECT count(1)
                              FROM reviews
                              WHERE reviews.user_id = users.id)
		SQL
  end
end
