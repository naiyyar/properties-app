class BillingService
	attr_accessor :payment_token, :customer_email, :description

	def initialize payment_token=nil, customer_email=nil, description=nil
		@payment_token 	= payment_token
		@customer_email = customer_email
		@description 		= description
	end

	def get_saved_cards current_user
		cards = []
		current_user.billings.pluck(:stripe_customer_id).map do |cust_id|
			#payment_methods = Stripe::PaymentMethod.list({customer: cust_id, type: 'card'})
			#data = payment_methods.data[0]
			#card = data['card']
			#card = get_stripe_card(stripe_object_ids)
			begin
				card = fetch_card(cust_id)
				cards << { 	id:         	card['id'],
										customer_id:	cust_id,
										brand: 				card['brand'], 
										exp_month: 		card['exp_month'], 
										exp_year: 		card['exp_year'], 
										last4: 				card['last4'] 
									} if card.present?
			rescue Timeout::Error
				puts 'That took too long, exiting...'
			end
		end
		return cards
	end

	def fetch_card cust_id
		card = Stripe::Customer.list_sources(cust_id).data.first
	end

	# def get_stripe_card stripe_object_ids
	# 	customer_id, card_id = stripe_object_ids[0], stripe_object_ids[1]
	# 	Stripe::Customer.retrieve_source(
	# 	  customer_id,
	# 	  card_id,
	# 	)
	# end

	def create_stripe_customer
		Stripe::Customer.create(email: @customer_email, card: @payment_token)
	end

	# def create_stripe_card customer_id
	# 	Stripe::Customer.create_source(customer_id, { source: @payment_token })
	# end

	def create_stripe_charge customer_id
		Stripe::Charge.create(
    	customer:  		customer_id,
      amount: 	 		Billing::PRICE * 100,
      currency:  		'usd',
      description: 	@description
    )
	end
end