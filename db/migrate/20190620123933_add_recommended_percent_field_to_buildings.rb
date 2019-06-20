class AddRecommendedPercentFieldToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :recommended_percent, :float
  end
end
