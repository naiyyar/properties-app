class BillingMailer < ApplicationMailer
	DEFAULT_EMAIL_WITH_NAME = %(transparentcity <hello@transparentcity.co>)
	
	def send_payment_receipt options={}
		@billing = options[:billing]
		to_email = options[:to_email].present? ? options[:to_email] : @billing&.email
		user 		 = @billing.user
		@view		 = options[:view] || 'mail'
		@card 	 = BillingService.new.get_card(user.stripe_customer_id, @billing.billing_card_id) rescue nil
		mail(
			to: to_email,
			from: DEFAULT_EMAIL_WITH_NAME,
			subject: "Payment Receipt (Invoice ##{@billing.id})"
		)
	end

	def no_card_payment_failed to_email
		mail(
			to: to_email,
			from: DEFAULT_EMAIL_WITH_NAME,
			subject: 'Your most recent invoice payment failed.'
		)
	end

	def payment_failed to_email
		mail(
			to: to_email,
			from: DEFAULT_EMAIL_WITH_NAME,
			subject: 'Your most recent invoice payment failed.'
		)
	end

	# def send_renew_reminder to_email, featured_building
	# 	@renew_date = featured_building.end_date - 2.days
	# 	@user_name 	= featured_building.user.try(:name)
	# 	mail(
	# 		to: to_email,
	# 		from: EMAIL_WITH_NAME,
	# 		subject: 'Subscription Renewal Reminder'
	# 	)
	# end

end
