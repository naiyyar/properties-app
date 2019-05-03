class AddActiveEmailAndActiveWebFieldToBuildings < ActiveRecord::Migration
  def self.up
    add_column :buildings, :active_email, :boolean, default: true
    add_column :buildings, :active_web, :boolean, default: true
  end

  def self.down
    remove_column :buildings, :active_email
    remove_column :buildings, :active_web
  end
end
