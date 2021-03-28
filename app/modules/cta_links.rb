module CTALinks
  def all_three_cta? listings_count
    active_web_url? && has_active_email? && listings_count > 0
  end

  def availability_and_contacts_cta?
    active_web_url? && has_active_email?
  end

  def all_contact_link?
    apply_and_leasing? && active_web_url? && schedule_tour?
  end

  def apply_and_availability_and_leasing?
    apply_and_availability? && show_contact_leasing?
  end

  def availability_tour_and_leasing?
    leasing_and_availability? && schedule_tour?
  end

  def apply_and_tour_and_availability?
    apply_and_availability? && schedule_tour?
  end

  def apply_and_leasing?
    show_apply_link? && show_contact_leasing?
  end

  def apply_and_availability?
    show_apply_link? && active_web_url?
  end

  def leasing_and_availability?
    show_contact_leasing? && active_web_url?
  end

  def availability_and_tour?
    availability? && schedule_tour?
  end

  def availability?
    active_web_url? && !(apply_and_leasing?)
  end

  def apply?
    show_apply_link? && !(leasing_and_availability?)
  end
  
  def has_active_email?
    email.present? && active_email
  end

  def active_web_url?
    web_url.present? && active_web
  end

   def show_apply_link?
    online_application_link.present? && show_application_link 
  end

  def show_contact_leasing?
    email.present? && active_email
  end

  def schedule_tour?
    schedule_tour_url.present? && schedule_tour_active
  end
end