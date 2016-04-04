class AddBuildingNameIdToReviews < ActiveRecord::Migration
  def change
        add_column :reviews, :building_name_id, :integer
  end
end
