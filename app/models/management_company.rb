=begin 
	======Schema =======
	name 			string
	website 	string
=end

class ManagementCompany < ActiveRecord::Base
	has_many :buildings
	validates :website, :url => true, allow_blank: true

	#pgsearch
	include PgSearch
  pg_search_scope :text_search_by_management_company, against: [:name],
     :using => { :tsearch => { prefix: true } }

	
	#methods

	def to_param
    if name.present?
      "#{id} #{name}".parameterize
    end
  end
	
	def add_building building_ids
		Building.where(id: building_ids).update_all(management_company_id: self.id)
	end

	def aggregate_reviews
		count = 0
		self.buildings.each do |building|
			count += building.reviews.count
		end
		count
	end

	def recommended_percent
		count = 0
		self.buildings.each do |building|
			count += building.recommended_percent unless building.recommended_percent.nan?
		end
		count/self.buildings.count
	end

	# def aggregate_rating
	# 	count = 0
	# 	self.buildings.each do |building|
	# 		count += building.reviews.count
	# 	end
	# 	count
	# end

end
