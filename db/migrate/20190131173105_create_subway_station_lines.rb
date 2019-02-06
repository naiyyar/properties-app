class CreateSubwayStationLines < ActiveRecord::Migration
  def change
    create_table :subway_station_lines do |t|
      t.integer :subway_station_id
      t.string :line
      t.string :color

      t.timestamps null: false
    end
  end
end
