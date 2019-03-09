class FeaturedBuilding < ActiveRecord::Base
	include PgSearch
	belongs_to :building

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
end
