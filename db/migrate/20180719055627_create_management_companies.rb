class CreateManagementCompanies < ActiveRecord::Migration
  def self.up
    create_table :management_companies do |t|
      t.string :name
      t.string :website

      t.timestamps null: false
    end
  end

  def self.down
  	drop_table :management_companies
  end
end
