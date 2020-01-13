class ChangeStartDateAndEndDateFieldTypeInFeaturedBuildings < ActiveRecord::Migration[5.0]
  def change
  	change_column :featured_buildings, :start_date, :datetime
  	change_column :featured_buildings, :end_date, 	:datetime
  end
end
