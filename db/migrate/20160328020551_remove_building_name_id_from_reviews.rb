class RemoveBuildingNameIdFromReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :building_name_id
  end
end
