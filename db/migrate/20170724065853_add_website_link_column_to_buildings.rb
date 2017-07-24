class AddWebsiteLinkColumnToBuildings < ActiveRecord::Migration
  def self.up
  	add_column :buildings, :web_url, :string
  end

  def self.down
  	remove_column :buildings, :website_url, :string
  end
end
