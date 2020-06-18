module RenewPlan
	#expired_featurings when renew is false and end_date is less than today's date then expire
  def set_expired_plans_to_inactive_if_autorenew_is_off billables
    billables.where(renew: false).each do |billable|
      Time.zone = billable.user.timezone
      billable.update(active: false) if billable.expired?
    end
  end

  def renew_and_deactivate_featured_plan
    billables = self.by_manager
    set_expired_plans_to_inactive_if_autorenew_is_off(billables.active)
    #renew
    billables.where(renew: true).each do |billable|
      user      = billable.user
      Time.zone = user.timezone
      if billable.not_already_renewed?(ENV['SERVER_ROOT'])
        if (customer_id = user.stripe_customer_id).present?
          card = BillingService.new(user).saved_cards(customer_id).last rescue nil
          if card.present?
            @billing = Billing.create_billing(user:         user, 
                                              card:         card, 
                                              customer_id:  customer_id, 
                                              id:           billable.id,
                                              type:         billable.class.name)
          else
            BillingMailer.no_card_payment_failed(user.email).deliver
          end
        end
      end
    end
  end
end
