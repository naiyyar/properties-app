class BillingMailer < ApplicationMailer
	EMAIL_WITH_NAME = %(transparentcity <hello@transparentcity.co>)
	
	def send_payment_receipt billing, card=nil
		@billing = billing
		to_email = @billing.email
		@card 	 = card
		mail(
			to: to_email,
			from: EMAIL_WITH_NAME,
			subject: 'Payment Receipt'
		)
	end

	def send_renew_reminder to_email, featured_building
		@renew_date = featured_building.end_date - 2.days
		@user_name 	= featured_building.user.try(:name)
		mail(
			to: to_email,
			from: EMAIL_WITH_NAME,
			subject: 'Subscription Renewal Reminder'
		)
	end

end
