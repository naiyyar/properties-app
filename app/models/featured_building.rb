class FeaturedBuilding < ApplicationRecord
  include PgSearch
  belongs_to :building
  belongs_to :user
  has_one    :billing #, :dependent => :destroy

  CURRENT_DT = Time.now

  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }
  scope :not_expired, -> { where('end_date is not null AND end_date >= ?', CURRENT_DT.to_s(:no_timezone)) }
  scope :expired,     -> { where('end_date is not null AND end_date < ?',  CURRENT_DT.to_s(:no_timezone)) }
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
    start_date.blank? and end_date.blank? and !active
  end

  def live?
    !draft? and end_date.to_s(:no_timezone) > CURRENT_DT.to_s(:no_timezone)
  end

  def expired?
    !live?
  end

  DEV_HOSTS = %w(http://localhost:3000 https://aptreviews-app.herokuapp.com)

  def renew_plan? host
    if DEV_HOSTS.include?(host)
      end_date.present? and CURRENT_DT.to_s(:no_timezone) == (end_date - 1.day).to_s(:no_timezone)
    else
      end_date.present? and CURRENT_DT.to_s(:no_timezone) == (end_date - 2.day).to_s(:no_timezone)
    end
    #end_date.present? and CURRENT_DT.to_date == (end_date - 1.day).to_date
  end

  def set_expiry_date renew_date
    update(start_date: _start_date, end_date: _end_date(renew_date), active: true, renew: true)
  end

  def _start_date
    (start_date.present? and end_date > CURRENT_DT) ? start_date : CURRENT_DT
  end

  def _end_date renew_date
    #en_date= (std + 27.days) #for 4 weeks on prodcution
    renew_date.present? ? (renew_date + 2.days) : (_start_date + 2.days) #for 1 day on dev
  end

  def draft_edit?
    !new_record? and live?
  end

  def self.expired_featurings
    by_manager.expired
  end

  def self.set_expired_plans_to_inactive
    expired_featurings.update_all(active: false, renew: false) if expired_featurings.active.any?
  end

  def self.set_expired_plans_to_inactive_if_autorenew_is_off
    if expired_featurings.any?
      autorenew_off_plans = expired_featurings.where(renew: false)
      autorenew_off_plans.update_all(active: false) if autorenew_off_plans.present?
    end
  end

  private

  def start_dt
    Time.zone.local(start_date.year, start_date.month, start_date.day, @hour, @min, @sec)
  end

  def end_dt
    Time.zone.local(end_date.year, end_date.month, end_date.day, @hour, @min, @sec)
  end

  def make_active
    if start_date.present? and end_date.present?
      @hour, @min, @sec = created_at.hour, created_at.min, created_at.sec
      update_columns(active: true, start_date: start_dt, end_date: end_dt)
    end
  end
  
  def check_active_status
    errors.add :base, 'Cannot delete unexpired featured buildings.'
    false
    throw(:abort)
  end
end
