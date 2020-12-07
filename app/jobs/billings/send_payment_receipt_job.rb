module Billings
	class SendPaymentReceiptJob < ApplicationJob
		queue_as :default

		def perform billing_id, current_user_id, email, view_param
			current_user = User.find(current_user_id)
	    billing 		 = Billing.find(billing_id)
			card 	  		 = billing.card(current_user, current_user.stripe_customer_id)
	    
	    billing.send_receipt_in_email(email, view_param, card)
	  end
	end
end