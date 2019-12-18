class Billing < ApplicationRecord
	PRICE = 49
	belongs_to :user
	belongs_to :featured_building

	attr_accessor :payment_token, :customer_email, :description

	after_save :set_featured_building_end_date, on: :create
	#after_destroy :remove_stripe_card

	def save_and_make_payment!
		if valid?
      begin
      	billing_service 				= BillingService.new(payment_token, customer_email, description)
      	customer 								= billing_service.create_stripe_customer
      	#card 		 								= billing_service.create_stripe_card(customer.id)
      	self.stripe_customer_id = customer.id
      	#self.stripe_card_id 		= card.id
        charge 									= billing_service.create_stripe_charge(customer.id)
        self.stripe_charge_id 	= charge.id
        save
      rescue Stripe::CardError => e
        errors.add :credit_card, e.message
        false
      end
    end
	end

	private
	def set_featured_building_end_date
		start_date = Date.today
		featured_building = FeaturedBuilding.find(featured_building_id)
		featured_building.update(start_date: start_date, end_date: start_date + 1.month, active: true)
		BillingMailer.send_payment_receipt(self, customer_email).deliver
	end

	# def remove_stripe_card
	# 	Stripe::Customer.delete_source(
	# 	  stripe_customer_id,
	# 	  stripe_card_id,
	# 	)
	# end
	
end
