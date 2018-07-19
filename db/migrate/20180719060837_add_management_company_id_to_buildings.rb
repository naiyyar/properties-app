class AddManagementCompanyIdToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :management_company_id, :integer
  end
end
