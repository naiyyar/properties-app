class AddImageFieldToVideoTours < ActiveRecord::Migration[5.0]
  def change
  	add_attachment :video_tours, :image
  end
end
