class AddTourableIdAndTourableTypeToVideoTours < ActiveRecord::Migration[5.0]
  def change
    add_column :video_tours, :tourable_id, :integer, index: true
    add_column :video_tours, :tourable_type, :string, index: true

    VideoTour.all.each do |tour|
    	if tour.tourable_id.blank?
    		tour.update_columns(tourable_id: tour.building_id, tourable_type: 'Building')
    	end
    end

    # remove_column :video_tours, :building_id
  end
end
