class BillingMailer < ApplicationMailer
	EMAIL_WITH_NAME = %(transparentcity <hello@transparentcity.co>)
	
	def send_payment_receipt billing, to_email=nil
		@billing = billing
		to_email = to_email.present? ? to_email : @billing&.email
		user 		 = billing.user
		@card 	 = BillingService.new.get_card(user.stripe_customer_id, billing.billing_card_id) rescue nil
		mail(
			to: to_email,
			from: EMAIL_WITH_NAME,
			subject: "Payment Receipt (Invoice ##{billing.id})"
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
