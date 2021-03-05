module Billable
	extend ActiveSupport::Concern
	
  included do
		has_many :billings, as: :billable #, dependent: :destroy

    after_destroy :destroy_billings
	end

  DEV_HOSTS = %w(http://localhost:3003 https://aptreviews-app.herokuapp.com)

  def model_class
    @model_class ||= self.class.name.constantize
  end

  def charging_amount
    model_class::AMOUNT
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

  def draft_edit?
    !new_record? && live?
  end

   def _end_date renew_date
    set_end_date(renew_date, days_count)
  end

  def days_count
    if DEV_HOSTS.include?(ENV['SERVER_ROOT']) 
      2.days
    else
      (model_class::FEATURING_DAYS - 1).days
    end
  end

  def set_end_date renew_date, days
    renew_date.present? ? (renew_date + days) : (_start_date + days)
  end

  def renew_time day_before
    end_date.present? && (end_date - day_before).to_s(:no_timezone) == Time.zone.now.to_s(:no_timezone)
  end

  def not_already_renewed? host=nil
    host = host || ENV['SERVER_ROOT']
    DEV_HOSTS.include?(host) ? renew_time(1.day) : renew_time(2.day)
  end

  private

  def make_active
    update_columns(active: true) if has_start_and_end_date? && end_date >= Time.zone.now
  end

  def destroy_billings
    self.billings.destroy_all
  end
end