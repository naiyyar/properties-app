class FeaturedBuilding < ApplicationRecord
  DEV_HOSTS = %w(http://localhost:3000 https://aptreviews-app.herokuapp.com)
  include PgSearch
  belongs_to :building
  belongs_to :user
  has_many   :billings #, :dependent => :destroy

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
    building_ids       = featured_buildings.pluck(:building_id)
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

  def featured_by_manager?
    featured_by == 'manager'
  end

  def has_start_and_end_date?
    start_date.present? && end_date.present?
  end

  def draft?
    start_date.blank? && end_date.blank? && !active
  end

  def live?
    end_date.present? ? (!draft? && end_date.to_s(:no_timezone) > Time.zone.now.to_s(:no_timezone)) : false
  end

  def expired?
    !live?
  end

  def set_expiry_date renew_date
    update(start_date: _start_date, end_date: _end_date(renew_date), active: true, renew: true)
  end

  def _start_date
    (start_date.present? && end_date > Time.zone.now) ? start_date : Time.zone.now
  end

  def _end_date renew_date
    DEV_HOSTS.include?(ENV['SERVER_ROOT']) ? set_end_date(renew_date, 2.days) : set_end_date(renew_date, 27.days)
  end

  def set_end_date renew_date, days
    renew_date.present? ? (renew_date + days) : (_start_date + days)
  end

  def draft_edit?
    !new_record? && live?
  end

  #expired_featurings when renew is false and end_date is less than today's date then expire
  def self.set_expired_plans_to_inactive_if_autorenew_is_off buildings
    buildings.where(renew: false).each do |featured_building|
      Time.zone = featured_building.user.timezone
      featured_building.update(active: false) if featured_building.expired?
    end
  end

  def self.renew_and_deactivate_featured_plan
    buildings = self.by_manager
    self.set_expired_plans_to_inactive_if_autorenew_is_off(buildings.active)
    #renew
    buildings.where(renew: true).each do |featured_building|
      user      = featured_building.user
      Time.zone = user.timezone
      if featured_building.not_already_renewed?(ENV['SERVER_ROOT'])
        if (customer_id = user.stripe_customer_id).present?
          card = BillingService.new.saved_cards(customer_id).last rescue nil
          if card.present?
            @billing = Billing.create_billing(user:                 user, 
                                              card:                 card, 
                                              customer_id:          customer_id, 
                                              featured_building_id: featured_building.id)
          else
            BillingMailer.no_card_payment_failed(user.email).deliver
          end
        end
      end
    end
  end

  def renew_time day_before
    end_date.present? && (end_date - day_before).to_s(:no_timezone) == Time.zone.now.to_s(:no_timezone)
  end

  def not_already_renewed? host=nil
    DEV_HOSTS.include?(ENV['SERVER_ROOT']) ? renew_time(1.day) : renew_time(2.day)
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
