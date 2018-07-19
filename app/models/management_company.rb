=begin 
	======Schema =======
	name 			string
	website 	string
=end

class ManagementCompany < ActiveRecord::Base
	has_many :buildings

	def add_building building_id
		Building.where(id: building_id).update_all(management_company_id: self.id)
	end
end
