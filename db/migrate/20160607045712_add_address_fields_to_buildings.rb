class AddAddressFieldsToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings,  :address2, :string
    add_column :buildings,  :zipcode, :string
    add_column :buildings,  :webaddress, :string
    add_column :buildings,  :city, :string
    add_column :buildings,  :phone, :string
    add_column :buildings,  :state, :string
  end
end
