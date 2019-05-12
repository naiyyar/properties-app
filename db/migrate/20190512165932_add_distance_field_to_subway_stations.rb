class AddDistanceFieldToSubwayStations < ActiveRecord::Migration
  def change
    add_column :subway_stations, :st_distance, :float
    add_column :subway_stations, :st_duration, :string
  end
end
