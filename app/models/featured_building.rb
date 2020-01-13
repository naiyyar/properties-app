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
    !draft? and end_date > Date.today
  end

  def expired?
    !live?
  end

  DEV_HOST = %w(http://localhost:3000 https://aptreviews-app.herokuapp.com)

  def renew_plan? host
    if DEV_HOST.include?(host)
      #end_date.present? and Date.today == end_date - 1.days
      #12 hrs before 
      #end_date.present? and ((end_date.to_time - Date.today.to_time) / 1.hour).to_i == 12
      end_date.present? and Date.today == end_date - 1.days
    else
      end_date.present? and Date.today == end_date - 2.days
    end
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
