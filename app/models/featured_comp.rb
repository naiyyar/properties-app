class FeaturedComp < ApplicationRecord
	include PgSearch
	belongs_to :building
	has_many :featured_comp_buildings
	has_many :buildings, through: :featured_comp_buildings, :dependent => :destroy

	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }

  pg_search_scope :search_query, 
  								against: [:id], 
  								associated_against: {
								    building: [:building_name, :building_street_address]
								  }

	filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  def add_featured_building building_ids
  	building_ids.reject{|c| c.empty?}.map do |id|
  		self.featured_comp_buildings.create(building_id: id)
  	end
	end
end
