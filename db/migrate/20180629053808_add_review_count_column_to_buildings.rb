class AddReviewCountColumnToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :reviews_count, :integer
  end
end
