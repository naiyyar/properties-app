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

	def get_average_stars
  	@total_rates = 0
    star_counts = []

    @total_rates = RatingCache.where(cacheable_id: buildings.pluck(:id))
                              .joins('LEFT JOIN buildings on rating_caches.cacheable_id = buildings.id')
                              .where.not(avg: [nil, 'NaN']).sum(:avg)
    # buildings.each do |building|
    #   rating_cache = building.rating_cache
    #   @total_rates += rating_cache.first.avg.to_f if rating_cache.present? and !rating_cache.first.avg.nan?
    # end
    
    star_counts = (@total_rates.to_f/aggregate_reviews).round(2).to_s.split('.')
    return star_counts
  end

end
