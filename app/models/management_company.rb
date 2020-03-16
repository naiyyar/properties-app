 # == Schema Information
#
# Table name: management_companies
#
#  id         :integer          not null, primary key
#  name       :string
#  website    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

=begin 
	======Schema =======
	name 			string
	website 	string
=end

class ManagementCompany < ApplicationRecord
	has_many :buildings
	validates :website, :url => true, allow_blank: true

	# pgsearch
	include PgSearch
  pg_search_scope :text_search_by_management_company, against: [:name],
                  :using => { :tsearch => { prefix: true } }

	# methods

	def to_param
    if name.present?
      "#{id} #{name}".parameterize
    end
  end

  def company_buildings
  	buildings.includes(:featured_buildings, :uploads, :building_average)
  					 .reorder(neighborhood: :asc, building_name: :asc, building_street_address: :asc)
  end

  def cached_company_buildings_count
  	company_buildings.count
  end

  def active_email_buildings?
  	company_buildings.with_active_email.present?
  end

  def active_website_buildings?
  	company_buildings.with_active_web.present?
  end

  def apply_link?
    company_buildings.with_application_link.present?
  end

  def cached_buildings
  	Rails.cache.fetch([self, 'company_buildings']) { company_buildings }
  end
	
	def add_building building_ids
		Building.where(id: building_ids).update_all(management_company_id: self.id)
	end

	def aggregate_reviews managed_buildings
		managed_buildings.sum(:reviews_count)
	end

	def recommended_percent managed_buildings
		downcount = total_reviews = 0
		managed_buildings.includes(:votes).each do |building|
			if building.reviews_count.to_i > 0
				downcount     += building.downvotes_count
				total_reviews += building.reviews_count
			end
		end
		return ((total_reviews - downcount).to_f / total_reviews) * 100
	end

	def get_average_stars managed_buildings, review_count
    star_counts  = []
    @total_rates = Rate.rateables(managed_buildings).where('stars > ?', 0).sum(:stars)
    star_counts  = (@total_rates.to_f/review_count).round(2).to_s.split('.')
    return star_counts
  end

end
