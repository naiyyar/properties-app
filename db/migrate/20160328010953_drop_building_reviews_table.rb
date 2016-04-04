class DropBuildingReviewsTable < ActiveRecord::Migration
  def change
    drop_table :building_reviews
  end
end
