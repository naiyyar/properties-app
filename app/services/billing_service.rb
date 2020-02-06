class BillingService
	attr_accessor :payment_token, :customer_email

	def initialize payment_token=nil, customer_email=nil
		@payment_token 	= payment_token
		@customer_email = customer_email
	end

	def get_saved_cards current_user
		saved_cards(current_user&.stripe_customer_id)
	end

	def saved_cards cust_id
		customer.list_sources(cust_id).data rescue nil
	end

	def get_card customer_id, card_id
		customer.retrieve_source(customer_id, card_id)
	end

	def create_stripe_customer
		customer.create(email: @customer_email, description: "Customer for #{@customer_email}")
	end

	def create_source cust_id
		customer.create_source(cust_id,{ source: @payment_token })
	end

	def get_charge charge_id
		stripe_charge.retrieve(charge_id)
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

	def create_charge! options={}
		billing = options[:billing]
		charge  = create_stripe_charge(billing, options[:customer_id], options[:card_id])
		billing.update_column(:stripe_charge_id, charge.id) if charge.present?
	end

	def create_stripe_charge billing, customer_id, card_id=nil
		stripe_charge.create(
    	customer:  		customer_id,
    	card: 				card_id,
      amount: 	 		Billing::PRICE * 100,
      currency:  		'usd',
      description: 	billing.billing_description,
      receipt_email: @customer_email
    )
	end

	private
	def customer
		Stripe::Customer
	end

	def stripe_charge
		Stripe::Charge
	end
end