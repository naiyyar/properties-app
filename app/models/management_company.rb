=begin 
	======Schema =======
	name 			string
	website 	string
=end

class ManagementCompany < ActiveRecord::Base
	has_many :buildings

	#methods
	
	def add_building building_id
		Building.where(id: building_id).update_all(management_company_id: self.id)
	end

	def aggregate_reviews
		count = 0
		self.buildings.each do |building|
			count += building.reviews.count
		end
		count
	end

	# def aggregate_rating
	# 	count = 0
	# 	self.buildings.each do |building|
	# 		count += building.reviews.count
	# 	end
	# 	count
	# end

end
