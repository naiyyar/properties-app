class AddScrapedFieldToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :scraped, :boolean, default: false
  end
end
