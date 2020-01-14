class FeaturedBuilding < ApplicationRecord
  include PgSearch
  belongs_to :building
  belongs_to :user
  has_one :billing #, :dependent => :destroy

  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }
  scope :not_expired, -> { where('end_date is not null AND end_date >= ?', Time.now.to_s(:no_timezone)) }
  scope :expired,     -> { where('end_date is not null AND end_date < ?', Time.now.to_s(:no_timezone)) }
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

  before_destroy :check_status, unless: Proc.new{ |obj| obj.expired? }

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
    !draft? and end_date.to_s(:no_timezone) > Time.now.to_s(:no_timezone)
  end

  def expired?
    !live?
  end

  DEV_HOSTS = %w(http://localhost:3000 https://aptreviews-app.herokuapp.com)

  def renew_plan? host
    if DEV_HOSTS.include?(host)
      #end_date.present? and Date.today == end_date - 1.days
      #12 hrs before 
      #end_date.present? and ((end_date.to_time - Date.today.to_time) / 1.hour).to_i == 12
      end_date.present? and Time.now.to_date == end_date.to_date - 1.day
    else
      end_date.present? and Time.now.to_s(:no_timezone) == end_date.to_s(:no_timezone) - 2.days
    end
  end

  def set_expiry_date renew_date
    std     = start_date.present? ? start_date : Time.now
    #en_date= (std + 27.days) #for 4 weeks on prodcution
    en_date = renew_date.present? ? (renew_date + 2.days) : (std + 2.days) #for 1 day on dev
    update(start_date: std, end_date: en_date, active: true, renew: true)
  end

  #Later
  # def send_renew_reminder?
  #   end_date.present? and Date.today == end_date - 4.days
  # end

  private
  def check_status
    errors.add :base, 'Cannot delete active featured buildings.'
    false
    throw(:abort)
  end
end
