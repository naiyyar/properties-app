class FeaturedBuilding < ApplicationRecord
  include PgSearch::Model
  include Billable

  extend RenewPlan

  FEATURING_WEEKS = 'four'
  FEATURING_DAYS = 28
  AMOUNT = 49
  
  belongs_to :user
  belongs_to :building, touch: true
  counter_cache_with_conditions :building, :featured_buildings_count, active: true

  # scopes
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
  
  # callbacks
  after_save :make_active, unless: :featured_by_manager?
  before_destroy :check_active_status, unless: Proc.new{ |obj| obj.expired? }

  def self.active_building_ids building_ids
    active_featured_buildings(building_ids).pluck(:building_id)
  end

  FBS_COUNT = 4
  def self.get_random_buildings buildings
    featured_buildings = self.active.limit(FBS_COUNT).order(Arel.sql('random()'))
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
             .order(Arel.sql('random()')).pluck(:id)
  end

  # Using when no buildings found after appling filters
  def self.active_in_neighborhood buildings, search_query
    @buildings = buildings
    return if @buildings.blank?
    searched_featured_buildings(search_query)
  end

  def self.active_featured_buildings building_ids
    where(building_id: building_ids).active
  end

  private

  def self.searched_featured_buildings search_query
    @buildings.joins(:featured_buildings)
              .where('featured_buildings.active is true')
              .random_order.limit(2)
  end
  
  def check_active_status
    errors.add :base, 'Cannot delete unexpired featured buildings.'
    false
    throw(:abort)
  end
end
