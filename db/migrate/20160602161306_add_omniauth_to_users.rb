class AddOmniauthToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :image_url, :string
  end

  def self.down
    remove_column :users, :provider
    remove_column :users, :uid
  end
end
