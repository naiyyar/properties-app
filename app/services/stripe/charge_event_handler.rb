module Stripe
	class ChargeEventHandler
    def call(event)
      begin
        method = "handle_" + event.type.tr('.', '_')
        self.send method, event
      rescue JSON::ParserError => e
        # handle the json parsing error here
        raise # re-raise the exception to return a 500 error to stripe
      rescue NoMethodError => e
        #code to run when handling an unknown event
      end
    end

    def billing_user customer
      User.find_by(stripe_customer_id: customer)
    end

    def billing charge
      Billing.find_by(stripe_charge_id: charge)
    end

    def handle_charge_expired(event)
      puts 'handle_charge_expired'
    end

    def handle_charge_failed(event)
      puts 'handle_charge_failed'
      #object        = event.data.object
      #user          = billing_user(object.customer)
      #card          = object.payment_method_details.card
      #BillingMailer.payment_failed(brand: card.brand, last4: card.last4, to_email: user.email).deliver
    end

    def handle_charge_succeeded(event)
      puts 'handle_charge_succeeded'
      billing = billing(event.data.object.id)
      billing.update_status('Successful') if billing.present?
      #BillingMailer.send_payment_receipt(billing: billing).deliver
    end

  end
end