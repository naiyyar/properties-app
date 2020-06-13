module Billable
	extend ActiveSupport::Concern
	included do
		has_many :billings, as: :billable
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
end