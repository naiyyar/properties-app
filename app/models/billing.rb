class Billing < ApplicationRecord
	FEATURED_BUILDING_PRICE = 49
	FEATURED_AGENT_PRICE = 9
	
	belongs_to :billable, polymorphic: true
	belongs_to :user

	attr_accessor :description, :strp_customer_id
	validates_presence_of :email

	after_save :set_end_date, unless: :payment_failed?

	default_scope {order(created_at: :desc)}

	scope :for_type, -> (type) { where(billable_type: type )}

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
      	billing_service 			= BillingService.new(user, stripe_card_id)
      	customer_id 					= billing_service.get_customer_id
      	card 									= billing_service.create_source(customer_id)
      	self.billing_card_id 	= card.id
      	self.brand						= card.brand
      	self.last4            = card.last4
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
				billing_service = BillingService.new(options[:user], nil)
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
    billing  	 = Billing.new({email:           user_email,
                              amount:          PRICE,
                              billable_id: 		 options[:id],
                              billable_type:   options[:type],
                              user_id:         user.id,
                              renew_date:      Time.zone.now,
                              billing_card_id: card.id,
                              brand:           card.brand
                            })
    unless billing.save_and_charge_existing_card!(user: user, customer_id: options[:customer_id], card_id: card.id)
      billing.status = 'Failed'
      billing.save
    end
	end

	def inv_description
		"Featured #{billable_type == 'FeaturedAgent' ? 'Agent' : 'Building'} For Four Weeks Starting on"
	end

	def price
		billable_type == 'FeaturedAgent' ? FEATURED_AGENT_PRICE : FEATURED_BUILDING_PRICE
	end
	
	def billing_description
		billable = self.billable
		unless renew_date
			"ID #{billable.id} #{inv_description} #{billable.start_date&.strftime('%b %-d, %Y')}"
		else
			"ID #{billable.id} Renewed #{inv_description} #{(renew_date + 2.day).strftime('%b %-d, %Y')}"
		end
	end

	def card current_user, stripe_customer_id
		billing_service = BillingService.new(current_user)
		charge_obj 			= billing_service.get_charge(stripe_charge_id)
		billing_service.get_card(stripe_customer_id, charge_obj.payment_method) if charge_obj.present?
	end

	def set_end_date
		klass = self.billable_type.constantize
		klass.find(billable_id).set_expiry_date(self.renew_date)
	end

	def update_status status
    update_column(:status, status)
  end
	
end
