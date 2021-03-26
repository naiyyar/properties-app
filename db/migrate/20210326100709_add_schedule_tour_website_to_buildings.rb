class AddScheduleTourWebsiteToBuildings < ActiveRecord::Migration[5.0]
  def change
    add_column :buildings, :schedule_tour_url, :string
    add_column :buildings, :schedule_tour_active, :boolean, default: true
  end
end
