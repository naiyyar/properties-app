class BillingMailer < ApplicationMailer
	
	def send_payment_receipt options={}
		@billing = options[:billing]
		to_email = options[:to_email].present? ? options[:to_email] : @billing&.email
		user 		 = @billing.user
		@view		 = options[:view] || 'mail'
		@card 	 = options[:card]
		mail(
			to: to_email,
			from: DEFAULT_EMAIL,
			subject: "Payment Receipt (##{@billing.receipt_number})"
		)
	end

end
