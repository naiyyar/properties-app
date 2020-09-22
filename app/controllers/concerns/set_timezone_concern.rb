module SetTimezoneConcern
	extend ActiveSupport::Concern

	included do
		before_action :set_timezone, if: :user_signed_in?
		helper_method :browser_time_zone
	end

	def set_timezone
    Time.zone = current_user.time_zone
  end

  def browser_time_zone
    browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies[:timezone])
    browser_tz || Time.zone
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    Time.zone
  end
end