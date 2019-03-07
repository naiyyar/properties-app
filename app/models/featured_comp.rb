class FeaturedComp < ActiveRecord::Base
	include PgSearch
	belongs_to :building
	has_many :featured_buildings
	has_many :buildings, through: :featured_buildings, :dependent => :destroy

	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }

	pg_search_scope :search_query, against: [:id, :start_date, :end_date],
    :using => { :tsearch => { prefix: true } }

  pg_search_scope :search_query, associated_against: {
    building: [:building_name, :building_street_address],
    buildings: [:building_name, :building_street_address]
  }

	filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  def add_featured_building building_ids
  	building_ids.reject{|c| c.empty?}.map do |id|
  		self.featured_buildings.create(building_id: id)
  	end
	end
end
