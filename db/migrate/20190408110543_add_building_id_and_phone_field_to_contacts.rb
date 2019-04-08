class AddBuildingIdAndPhoneFieldToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :building_id, :integer
    add_column :contacts, :user_id, :integer
    add_column :contacts, :phone, :string
  end
end
