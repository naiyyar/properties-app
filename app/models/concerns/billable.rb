module Billable
	extend ActiveSupport::Concern
	included do
		has_many :billings, as: :billable
	end

  DEV_HOSTS = %w(http://localhost:3000 https://aptreviews-app.herokuapp.com)

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
    DEV_HOSTS.include?(ENV['SERVER_ROOT']) ? set_end_date(renew_date, 2.days) : set_end_date(renew_date, 27.days)
  end

  def set_end_date renew_date, days
    renew_date.present? ? (renew_date + days) : (_start_date + days)
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
end