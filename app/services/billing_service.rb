class BillingService
	attr_accessor :payment_token, :customer_email, :description

	def initialize payment_token=nil, customer_email=nil, description=nil
		@payment_token 	= payment_token
		@customer_email = customer_email
		@description 		= description
	end

	def get_saved_cards current_user
		saved_cards(current_user&.stripe_customer_id)
	end

	def saved_cards cust_id
		Stripe::Customer.list_sources(cust_id).data rescue nil
	end

	def get_card customer_id, card_id
		Stripe::Customer.retrieve_source(customer_id, card_id)
	end

	def create_stripe_customer
		Stripe::Customer.create(email: @customer_email, description: "Customer for #{@customer_email}")
	end

	def create_source cust_id
		Stripe::Customer.create_source(cust_id,{ source: @payment_token })
	end

	def get_customer_id current_user
		if current_user.stripe_customer_id.present?
      customer_id   = current_user.stripe_customer_id
    else
      customer_id   = self.create_stripe_customer.id
      current_user.update_column(:stripe_customer_id, customer_id)
    end
    return customer_id
	end

	def create_stripe_charge customer_id, card_id=nil
		Stripe::Charge.create(
    	customer:  		customer_id,
    	card: 			card_id,
      amount: 	 		Billing::PRICE * 100,
      currency:  		'usd',
      description: 	@description
    )
	end
end