class FeaturedBuilding < ActiveRecord::Base
  include PgSearch
  belongs_to :building

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :not_expired, -> { where('end_date is not null AND end_date >= ?', Date.today) }

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

  def self.active_featured_buildings building_ids
    where(building_id: building_ids).active.not_expired
  end

  def self.active_building_ids building_ids
    active_featured_buildings(building_ids).pluck(:building_id)
  end
end
