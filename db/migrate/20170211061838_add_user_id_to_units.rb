class AddUserIdToUnits < ActiveRecord::Migration
  def change
    add_column :units, :user_id, :integer
  end
end
