class AddReviewIdToVotes < ActiveRecord::Migration
  def change
  	add_column :votes, :review_id, :integer
  end
end
