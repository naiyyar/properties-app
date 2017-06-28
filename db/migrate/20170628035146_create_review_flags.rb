class CreateReviewFlags < ActiveRecord::Migration
  def change
    create_table :review_flags do |t|
    	t.integer :review_id
    	t.integer :user_id
    	t.text :flag_description
    	
      t.timestamps null: false
    end
  end
end
