module RenewPlan
  
  def create_billing(user, card, customer_id, billable)
    Billing.create_billing( user:        user, 
                            card:        card, 
                            customer_id: customer_id, 
                            billable:    billable )
  end

  def renew_and_deactivate_featured_plan
    billables = self.by_manager
    if billables.present?
      # Setting up autorenew to off when plan is active but expired
      set_expired_plans_to_inactive_if_autorenew_is_off(billables.active)
      # When renew is on and active is off and plan expired
      set_auto_renew_off_for_inactive_plans(billables.inactive)
      # Renew plan when active and renew is on
      renew_active_plans(billables)
    end
  end

  private

  # Expired_featurings when renew is false and end_date is less than today's date then expire
  def set_expired_plans_to_inactive_if_autorenew_is_off billables
    change_plan_status(billables, renew: false)
  end

  # Setting renew to false when expired but renew is on
  def set_auto_renew_off_for_inactive_plans inactive_billables
    change_plan_status(inactive_billables, renew: true)
  end

  def change_plan_status billables, status
    billables.where(renew: status[:renew]).each do |billable|
      set_time_zone(billable.user)
      update_status(billable) if billable.expired?
    end
  end

  def renew_active_plans billables
    billables.where(renew: true).each do |billable|
      user = billable.user
      if user.present?
        Time.zone   = user.timezone
        customer_id = user.stripe_customer_id
        if customer_id.present?
          cards = get_cards(user, customer_id)
          if cards.present?
            if billable.not_already_renewed?(ENV['SERVER_ROOT'])
              card = cards.last rescue nil
              create_billing(user, card, customer_id, billable) if card.present?
            end
          else
            # Updating plan status to false when no customer found
            set_time_zone(user) 
            update_status(billable) if billable.expired? && billable.active
          end
        end
      end
    end
  end

  def get_cards user, customer_id
    BillingService.new(user).saved_cards(customer_id)
  end

  def update_status billable
    billable.update_columns(active: false, renew: false)
  end

  def set_time_zone user
    Time.zone = user.timezone
  end

end
