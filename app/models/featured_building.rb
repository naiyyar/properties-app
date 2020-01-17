class FeaturedBuilding < ApplicationRecord
  include PgSearch
  belongs_to :building
  belongs_to :user
  has_one    :billing #, :dependent => :destroy

  LOCAL_TIME_WITHOUT_TIMEZONE = Time.now.localtime.to_s(:no_timezone)

  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }
  scope :not_expired, -> { where('end_date is not null AND end_date >= ?', LOCAL_TIME_WITHOUT_TIMEZONE) }
  scope :expired,     -> { where('end_date is not null AND end_date < ?', LOCAL_TIME_WITHOUT_TIMEZONE) }
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

  before_destroy :check_active_status, unless: Proc.new{ |obj| obj.expired? }

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

  def draft?
    !has_start_and_end_date? and !active
  end

  def live?
    !draft? and localtime_end_date.to_s(:no_timezone) > LOCAL_TIME_WITHOUT_TIMEZONE
  end

  def expired?
    !live?
  end

  def localtime_end_date
    end_date.localtime
  end

  DEV_HOSTS = %w(http://localhost:3000 https://aptreviews-app.herokuapp.com)

  def renew_plan? host
    if DEV_HOSTS.include?(host)
      end_date.present? and LOCAL_TIME_WITHOUT_TIMEZONE == (localtime_end_date - 1.day).to_s(:no_timezone)
    else
      end_date.present? and LOCAL_TIME_WITHOUT_TIMEZONE == (localtime_end_date - 2.day).to_s(:no_timezone)
    end
  end

  def set_expiry_date renew_date
    std     = start_date.present? ? start_date : Time.now
    #en_date= (std + 27.days) #for 4 weeks on prodcution
    en_date = renew_date.present? ? (renew_date + 2.days) : (std + 2.days) #for 1 day on dev
    update(start_date: std, end_date: en_date, active: true, renew: true)
  end

  def self.expired_featurings
    by_manager.expired
  end

  def self.set_expired_plans_to_inactive
    expired_featurings.update_all(active: false, renew: false) if expired_featurings.active.any?
  end

  def self.set_expired_plans_to_inactive_if_autorenew_id_off
    autorenew_off_plans = expired_featurings.where(renew: false)
    autorenew_off_plans.update_all(active: false) if autorenew_off_plans.present?
  end

  private
  def check_active_status
    errors.add :base, 'Cannot delete active featured buildings.'
    false
    throw(:abort)
  end
end
