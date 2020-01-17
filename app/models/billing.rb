class Billing < ApplicationRecord
	PRICE = 49
	belongs_to :user
	belongs_to :featured_building
	
	attr_accessor :description, :strp_customer_id
	validates_presence_of :email

	after_save :set_featured_building_end_date, :send_email

	default_scope {order(created_at: :desc)}

	def save_and_make_payment!
		if valid?
      begin
      	#stripe_card_id is same as payment_token
      	billing_service 			= BillingService.new(stripe_card_id, email, description)
      	customer_id 					= billing_service.get_customer_id(user)
      	card 									= billing_service.create_source(customer_id)
      	self.billing_card_id 	= card.id
      	self.brand						= card.brand
        charge 								= billing_service.create_stripe_charge(customer_id)
        self.stripe_charge_id = charge.id
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
				BillingService.new.create_stripe_charge(customer_id, billing_card_id)
			rescue Stripe::CardError => e
	      errors.add :credit_card, e.message
	      false
	    end
	  else
	  	errors.add(:base, 'Email can not be blank.')  if email.blank?
	  end
	end

	def billing_description
		fb = self.featured_building
		unless renew_date
			"Featured Building For Four Weeks Starting on #{fb.start_date&.strftime('%b %-d, %Y')}"
		else
			"ID #{fb.id} Renewed Featured Building For Four Weeks Starting on #{(renew_date + 2.day).strftime('%b %-d, %Y')}"
		end
	end

	private
	def set_featured_building_end_date
		fb = FeaturedBuilding.find(featured_building_id)
		fb.set_expiry_date(self.renew_date)
	end

	def send_email
		BillingMailer.send_payment_receipt(billing: self).deliver
	end
	
end
