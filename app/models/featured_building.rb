class FeaturedBuilding < ApplicationRecord
  include PgSearch
  belongs_to :building
  belongs_to :user
  has_one :billing #, :dependent => :destroy

  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }
  scope :not_expired, -> { where('end_date is not null AND end_date >= ?', Date.today) }
  scope :expired,     -> { where('end_date is not null AND end_date < ?', Date.today) }
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

  #before_destroy :check_status, unless: Proc.new{ |obj| obj.expired? }

  def featured_by_manager?
    featured_by == 'manager'
  end

  def self.active_featured_buildings building_ids
    where(building_id: building_ids).active
  end

  def self.active_building_ids building_ids
    active_featured_buildings(building_ids).pluck(:building_id)
  end

  def has_start_and_end_date?
    start_date.present? and end_date.present?
  end

  def live?
    start_date.present? and end_date.present? and end_date > Date.today
  end

  def expired?
    !live?
  end

  def renew_plan?
    end_date.present? and Date.today == end_date - 2.days
  end

  def send_renew_reminder?
    end_date.present? and Date.today == end_date - 4.days
  end

  private
  def check_status
    errors.add :base, 'Cannot delete active featured buildings.'
    false
    throw(:abort)
  end
end
