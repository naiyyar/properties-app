class Billing < ApplicationRecord
	PRICE = 49
	belongs_to :user
	belongs_to :featured_building

	attr_accessor :payment_token

	def save_and_make_payment!
		if valid?
      begin
        # charge = Stripe::Charge.create(
        #   amount: PRICE,
        #   currency: currency,
        #   source: payment_token,
        # )
        save
      rescue Stripe::CardError => e
        errors.add :credit_card, e.message
        false
      end
    end
	end
end
