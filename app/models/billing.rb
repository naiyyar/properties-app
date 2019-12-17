class Billing < ApplicationRecord
	PRICE = 49
	belongs_to :user
	belongs_to :featured_building

	attr_accessor :payment_token, :customer_email
	
	def save_and_make_payment!
		if valid?
      begin
      	customer = Stripe::Customer.create(
      		email: customer_email,
      		source: payment_token,
      	)
      	self.stripe_customer_id = customer.id
        charge = Stripe::Charge.create(
        	customer: customer.id,
          amount: PRICE * 100,
          currency: 'usd',
          description: 'TEST payment'
        )
        save
      rescue Stripe::CardError => e
        errors.add :credit_card, e.message
        false
      end
    end
	end

	# data": [
 #    {"id":"card_1FqjXcHc3YOlfsKIAcb4Qowd",
 #    	"object":"payment_method",
 #    	"billing_details":
 # 					{"address":{"city":null,"country":null,"line1":null,"line2":null,"postal_code":null,"state":null},
 # 						"email":null,"name":null,"phone":null
 # 					},
 # 					"card":{"brand":"visa",
 # 									"checks":{"address_line1_check":null,"address_postal_code_check":null,"cvc_check":"pass"},
 # 									"country":"US","exp_month":5,"exp_year":2024,"fingerprint":"juzde1LqyvtbQUCX","funding":"debit","generated_from":null,"last4":"5556",
 # 									"three_d_secure_usage":{"supported":true},"wallet":null},"created":1576602540,"customer":"cus_GNUWq2DddEPFdR","livemode":false,"metadata":{},"type":"card"}
 # #  ],
 	#Stripe::Customer.list.data[0].email

	def self.get_saved_cards current_user
		cards = []
		current_user.billings.pluck(:stripe_customer_id).map do |cust_id|
			payment_methods = Stripe::PaymentMethod.list({customer: cust_id, type: 'card'})
			data = payment_methods.data[0]
			card = data['card']
			cards << { 	brand: 			card['brand'], 
									exp_month: 	card['exp_month'], 
									exp_year: 	card['exp_year'], 
									last4: 			card['last4'] 
								}
		end
		return cards
	end
end
