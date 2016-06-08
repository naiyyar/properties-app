class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
    	t.attachment :image
    	t.integer :imageable_id
      t.string :imageable_type
      t.timestamps null: false
    end
  end
end
