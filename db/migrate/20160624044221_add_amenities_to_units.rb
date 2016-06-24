class AddAmenitiesToUnits < ActiveRecord::Migration
  def change
  	add_column :units, :balcony, 								 :boolean, default: false
		add_column :units, :board_approval_required, :boolean, default: false
		add_column :units, :converted_unit, 				 :boolean, default: false
		add_column :units, :courtyard, 							 :boolean, default: false
		add_column :units, :dishwasher, 						 :boolean, default: false
		add_column :units, :fireplace, 							 :boolean, default: false
		add_column :units, :furnished, 							 :boolean, default: false
		add_column :units, :guarantors_accepted, 		 :boolean, default: false
		add_column :units, :loft, 									 :boolean, default: false
		add_column :units, :management_company_run,  :boolean, default: false
		add_column :units, :rent_controlled, 				 :boolean, default: false
		add_column :units, :private_landlord, 			 :boolean, default: false
		add_column :units, :storage_available, 			 :boolean, default: false
		add_column :units, :sublet, 								 :boolean, default: false
		add_column :units, :terrace, 								 :boolean, default: false
		add_column :units,  :can_be_converted, 				:boolean, default: false
		add_column :units,  :dryer_in_unit, 						:boolean, default: false
  end
end
