class Billing < ApplicationRecord
	PRICE = 49
	INV_DESCRIPTION = 'Featured Building For Four Weeks Starting on'
	
	belongs_to :user
	belongs_to :featured_building
	
	attr_accessor :description, :strp_customer_id
	validates_presence_of :email

	#after_save :set_featured_building_end_date, :send_email, unless: :payment_failed?

	default_scope {order(created_at: :desc)}

	def payment_failed?
		status == 'Failed'
	end

	def save_and_make_payment!
		if valid?
      begin
      	#stripe_card_id is same as payment_token
      	billing_service 			= BillingService.new(stripe_card_id, email, description)
      	customer_id 					= billing_service.get_customer_id(user)
      	card 									= billing_service.create_source(customer_id)
      	self.billing_card_id 	= card.id
      	self.brand						= card.brand
      	self.last4            = card.last4
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

	def save_and_charge_existing_card! options={}
		if valid?
			begin
				billing_service 			= BillingService.new
				charge 								= billing_service.create_stripe_charge(options[:customer_id], options[:card_id])
			rescue Stripe::CardError => e
	      errors.add :credit_card, e.message
	      false
	    end
	    self.stripe_charge_id = charge.id if charge.present?
	    self.status 					= 'Failed'  if charge.blank?
			save
	  else
	  	errors.add(:base, 'Email can not be blank.')  if email.blank?
	  end
	end
	
	def billing_description
		fb = self.featured_building
		unless renew_date
			"ID #{fb.id} #{INV_DESCRIPTION} #{fb.start_date&.strftime('%b %-d, %Y')}"
		else
			"ID #{fb.id} Renewed #{INV_DESCRIPTION} #{(renew_date + 2.day).strftime('%b %-d, %Y')}"
		end
	end

	def set_featured_building_end_date
		fb = FeaturedBuilding.find(featured_building_id)
		fb.set_expiry_date(self.renew_date)
	end

	def update_status status
    update_column(:status, status)
  end
	
end
