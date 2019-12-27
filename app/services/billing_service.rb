class BillingService
	attr_accessor :payment_token, :customer_email, :description

	def initialize payment_token=nil, customer_email=nil, description=nil
		@payment_token 	= payment_token
		@customer_email = customer_email
		@description 		= description
	end

	def get_saved_cards current_user
		cust_id = current_user.create_stripe_customer
		cards = saved_cards(cust_id)
		cards.map do |card|
			begin
				cards << { 	id:         	card['id'],
										email: 				current_user.email,
										customer_id:	cust_id,
										brand: 				card['brand'], 
										exp_month: 		card['exp_month'], 
										exp_year: 		card['exp_year'], 
										last4: 				card['last4'] 
									} if card.present?
			rescue Timeout::Error
				puts 'Taking too long, exiting...'
			end
		end
		return cards
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

	def create_stripe_charge customer_id
		Stripe::Charge.create(
    	customer:  		customer_id,
      amount: 	 		Billing::PRICE * 100,
      currency:  		'usd',
      description: 	@description
    )
	end
end