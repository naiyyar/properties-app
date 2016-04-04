class RemoveBuildingIdFromReviews2 < ActiveRecord::Migration
  def change
    remove_column :reviews, :building_id 
  end
end
