class CreateSubwayStations < ActiveRecord::Migration
  def change
    create_table :subway_stations do |t|
      t.string :name
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
