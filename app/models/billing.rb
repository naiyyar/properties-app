class Billing < ApplicationRecord
	PRICE 					= 49
	INV_DESCRIPTION = 'Featured Building For Four Weeks Starting on'
	
	belongs_to :user
	belongs_to :featured_building
	
	attr_accessor :description, :strp_customer_id
	validates_presence_of :email

	after_save :set_featured_building_end_date, unless: :payment_failed?

	default_scope {order(created_at: :desc)}

	def payment_failed?
		status == 'Failed'
	end

	def payment_detail?
		billing_card_id && brand && last4
	end

	def save_and_make_payment!
		if valid?
      begin
      	#stripe_card_id is same as payment_token
      	billing_service 	= BillingService.new(stripe_card_id, email)
      	customer_id 			= billing_service.get_customer_id(user)
      	card 							= billing_service.create_source(customer_id)
      	self.billing_card_id 	= card.id
      	self.brand							= card.brand
      	self.last4            	= card.last4
        if self.save
        	billing_service.create_charge!(billing: self, customer_id: customer_id)
        end
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
				billing_service = BillingService.new(nil, options[:email])
				if save
					options.merge!(billing: self)
					billing_service.create_charge!(options)
				end
			rescue Stripe::CardError => e
	      errors.add :credit_card, e.message
	      false
	    end
	  else
	  	errors.add(:base, 'Email can not be blank.')  if email.blank?
	  end
	end

	def self.create_billing options={}
		user 		 	 = options[:user]
		card 		 	 = options[:card]
		user_email = user.email
    billing  	 = Billing.new({email:              	user_email,
                              amount:               PRICE,
                              featured_building_id: options[:featured_building_id],
                              user_id:              user.id,
                              renew_date:           Time.zone.now,
                              billing_card_id:      card.id,
                              brand:                card.brand
                            })
    unless billing.save_and_charge_existing_card!(customer_id: options[:customer_id], email: user_email, card_id: card.id)
      billing.status = 'Failed'
      billing.save
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

	def card stripe_customer_id
		billing_service = BillingService.new
		charge_obj 			= billing_service.get_charge(stripe_charge_id)
		billing_service.get_card(stripe_customer_id, charge_obj.payment_method) if charge_obj.present?
	end

	def set_featured_building_end_date
		fb = FeaturedBuilding.find(featured_building_id)
		fb.set_expiry_date(self.renew_date)
	end

	def update_status status
    update_column(:status, status)
  end
	
end
