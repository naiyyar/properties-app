class AddAvgRatingColumnToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :avg_rating, :float, index: true
  end
end
