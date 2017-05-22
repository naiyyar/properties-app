class AddNewAmenitiesToBuildings < ActiveRecord::Migration
  def change
  	remove_column :buildings, :deck
  	add_column :buildings, :courtyard, 							 :boolean, default: false
    add_column :buildings, :management_company_run,  :boolean, default: false
  end
end
