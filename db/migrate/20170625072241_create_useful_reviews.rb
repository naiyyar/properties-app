class CreateUsefulReviews < ActiveRecord::Migration
  def change
    create_table :useful_reviews do |t|
    	t.integer :review_id
    	t.integer :user_id
    	
      t.timestamps null: false
    end
  end
end
