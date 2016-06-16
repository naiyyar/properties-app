class AddFieldsToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :building_address, :string
  	add_column :reviews, :tenant_status, :string
  	add_column :reviews, :stay_time, :string
  	add_column :reviews, :pros, :string
  	add_column :reviews, :cons, :string
  	add_column :reviews, :other_advice, :string
  	rename_column :reviews, :building_review_title, :review_title
  end
end
