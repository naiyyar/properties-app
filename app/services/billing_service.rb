class BillingService
	attr_accessor :payment_token, :customer_email, :description

	def initialize payment_token=nil, customer_email=nil, description=nil
		@payment_token 	= payment_token
		@customer_email = customer_email
		@description 		= description
	end

	def get_saved_cards current_user
		cards = []
		current_user.billings.where.not(stripe_customer_id: nil).pluck(:stripe_customer_id).uniq.map do |cust_id|
			begin
				card = fetch_card(cust_id)
				cards << { 	id:         	card['id'],
										email: 				Stripe::Customer.retrieve(cust_id).email,
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

	def fetch_card cust_id
		Stripe::Customer.list_sources(cust_id).data.first rescue nil
	end

	def create_stripe_customer
		Stripe::Customer.create(email: @customer_email, card: @payment_token)
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