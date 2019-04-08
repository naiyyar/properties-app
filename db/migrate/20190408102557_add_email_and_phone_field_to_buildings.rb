class AddEmailAndPhoneFieldToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :email, :string, index: true
  end
end
