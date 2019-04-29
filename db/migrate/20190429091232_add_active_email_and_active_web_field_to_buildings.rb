class AddActiveEmailAndActiveWebFieldToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :active_email, :boolean, default: false
    add_column :buildings, :active_web, :boolean, default: false
  end
end
