class AddOnlineApplicationLinkToBuildings < ActiveRecord::Migration[5.0]
  def change
    add_column :buildings, :online_application_link, :string
    add_column :buildings, :show_application_link, 	 :boolean, default: true
  end
end
