class Billing < ApplicationRecord
	PRICE = 49
	belongs_to :user
	belongs_to :featured_building
	
	attr_accessor :description, :strp_customer_id
	validates_presence_of :email

	after_save :set_featured_building_end_date, :send_email

	def save_and_make_payment!
		if valid?
      begin
      	billing_service 				= BillingService.new(stripe_card_id, email, description)
      	customer 								= billing_service.create_stripe_customer
      	Customer.create(stripe_customer_id: customer.id, user_id: user_id)
      	self.strp_customer_id 	= customer.id
        charge 									= billing_service.create_stripe_charge(customer.id)
        self.stripe_charge_id 	= charge.id
        save
      rescue Stripe::CardError => e
        errors.add :credit_card, e.message
        false
      end
    else
    	errors.add(:base, 'Email can not be blank.')  if email.blank?
    end
	end

	def create_charge_existing_card! customer_id
		if valid?
			begin
				BillingService.new.create_stripe_charge(customer_id)
				self.strp_customer_id = customer_id
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
		end_date = (start_date + 27.days) #for 4 weeks
		featured_building.update(start_date: start_date, end_date: end_date, active: true, renew: true)
	end

	def send_email
		card = BillingService.new.fetch_card(self.strp_customer_id)
		self.update_column(:brand, card['brand'])
		BillingMailer.send_payment_receipt(self, card).deliver
	end
	
end
