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

end
