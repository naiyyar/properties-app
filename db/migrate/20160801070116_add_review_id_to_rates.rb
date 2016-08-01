class AddReviewIdToRates < ActiveRecord::Migration
  def change
    add_column :rates, :review_id, :integer
  end

  def self.down
  	remove_column :rates, :review_id
  end
end
