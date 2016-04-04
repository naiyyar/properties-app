class RemoveBuildingIdFromReviews < ActiveRecord::Migration
  def change
    remove_foreign_key :reviews, column: :building_id
  end
end
