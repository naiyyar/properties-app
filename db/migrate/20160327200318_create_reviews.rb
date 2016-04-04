class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :building_review_title

      t.timestamps null: false
    end
  end
end
