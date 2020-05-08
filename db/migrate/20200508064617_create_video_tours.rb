class CreateVideoTours < ActiveRecord::Migration[5.0]
  def change
    create_table :video_tours do |t|
    	t.integer :building_id
    	t.string :url
    	t.string :description
    	t.string :category
    	t.integer :sort
      t.timestamps
    end
  end
end
