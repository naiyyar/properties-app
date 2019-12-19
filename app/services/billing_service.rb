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
				puts 'Taking too long, exiting...'
			end
		end
		return cards
	end

	def fetch_card cust_id
		Stripe::Customer.list_sources(cust_id).data.first
	end

	def find_or_create_stripe_customer options={}
		billing 		 = options[:billing]
		current_user = options[:current_user]
		current_user = billing.user if billing.present?
		unless current_user.customer_id.present?
			customer = Stripe::Customer.create(email: @customer_email, card: @payment_token)
			current_user.update(customer_id: customer.id)
		else
			customer = Stripe::Customer.retrieve(current_user.customer_id)
		end
		return customer
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