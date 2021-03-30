class CTALinksPolicy
	attr_accessor :building
	
	def initialize building
		@building = building
	end

	def all_three_cta? listings_count
    availability_and_contacts_cta? && listings_count > 0
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

  def apply_and_tour_and_leasing?
    apply_and_leasing? && schedule_tour?
  end

  def apply_and_leasing?
    show_apply_link? && show_contact_leasing?
  end

  def apply_and_availability?
    show_apply_link? && active_web_url?
  end

  def availability_and_tour?
    availability? && schedule_tour?
  end

  def apply_and_tour?
    apply? && schedule_tour?
  end

  def availability?
    active_web_url? && !(apply_and_leasing?)
  end

  def apply?
    building.show_apply_link? && !(leasing_and_availability?)
  end

  def leasing_and_availability?
    show_contact_leasing? && active_web_url?
  end
  
  def has_active_email?
    building.email.present? && building.active_email
  end

  def active_web_url?
    building.web_url.present? && building.active_web
  end

   def show_apply_link?
    building.online_application_link.present? && building.show_application_link 
  end

  def show_contact_leasing?
    building.email.present? && building.active_email
  end

  def schedule_tour?
    building.schedule_tour_url.present? && building.schedule_tour_active
  end
end