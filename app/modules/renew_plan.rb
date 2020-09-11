module RenewPlan
  # Expired_featurings when renew is false and end_date is less than today's date then expire
  def set_expired_plans_to_inactive_if_autorenew_is_off billables
    billables.where(renew: false).each do |billable|
      set_time_zone(billable.user)
      update_status(billable) if billable.expired?
    end
  end

  def set_time_zone user
    Time.zone = user.timezone
  end

  def update_status billable
    billable.update(active: false, renew: false)
  end

  def create_billing(user, card, customer_id, billable)
    Billing.create_billing( user:         user, 
                            card:         card, 
                            customer_id:  customer_id, 
                            id:           billable.id,
                            type:         billable.class.name)
  end

  def renew_and_deactivate_featured_plan
    billables    = self.by_manager
    active_plans = billables.active
    set_expired_plans_to_inactive_if_autorenew_is_off(active_plans)
    # Renew
    billables.where(renew: true).each do |billable|
      user = billable.user
      if user.present?
        Time.zone   = user.timezone
        customer_id = user.stripe_customer_id
        if customer_id.present?
          cards = BillingService.new(user).saved_cards(customer_id)
          if cards.present?
            if billable.not_already_renewed?(ENV['SERVER_ROOT'])
              card = cards.last rescue nil
              create_billing(user, card, customer_id, billable) if card.present?
            end
          else
            # Updating plan status to false when no customer found
            set_time_zone(user) 
            if billable.expired? && billable.active
              update_status(billable)
              BillingMailer.no_card_payment_failed(user.email).deliver
            end
          end
        end
      end
    end
  end

end
