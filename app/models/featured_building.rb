class FeaturedBuilding < ApplicationRecord
  DEV_HOSTS = %w(http://localhost:3000 https://aptreviews-app.herokuapp.com)
  include PgSearch
  include Billable
  
  belongs_to :building
  counter_cache_with_conditions :building, :featured_buildings_count, active: true
  
  belongs_to :user
  # has_many   :billings #, :dependent => :destroy

  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }
  scope :by_manager,  -> { where(featured_by: 'manager') }

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
  after_save :make_active, unless: :featured_by_manager?
  before_destroy :check_active_status, unless: Proc.new{ |obj| obj.expired? }

  def self.active_featured_buildings building_ids
    where(building_id: building_ids).active
  end

  def self.active_building_ids building_ids
    active_featured_buildings(building_ids).pluck(:building_id)
  end

  FBS_COUNT = 4
  def self.get_random_buildings buildings
    featured_buildings = self.active.limit(FBS_COUNT).order('RANDOM()')
    building_ids       = featured_buildings.pluck(:building_id).uniq
    if building_ids.length < FBS_COUNT
      building_ids += active_buildings_ids_without_featured(buildings, building_ids)
    end
    return buildings.where(id: building_ids)
  end

  def self.active_buildings_ids_without_featured buildings, building_ids
    buildings.where.not(id: building_ids)
             .with_active_listing
             .limit(FBS_COUNT - building_ids.length)
             .order('RANDOM()').pluck(:id)
  end

  private

  def make_active
    update_columns(active: true) if has_start_and_end_date? && end_date >= Time.zone.now
  end
  
  def check_active_status
    errors.add :base, 'Cannot delete unexpired featured buildings.'
    false
    throw(:abort)
  end
end
