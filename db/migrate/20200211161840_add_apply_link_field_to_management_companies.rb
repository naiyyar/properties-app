class AddApplyLinkFieldToManagementCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :management_companies, :apply_link, :boolean, default: false
  end
end
