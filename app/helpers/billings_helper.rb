module BillingsHelper
	def brand_name brand=nil
		brand.present? ? brand.downcase.split(' ').join('_') : 'generic'
	end

	def previous_page_path
		params[:fb_id].present? ? edit_featured_building_path(params[:fb_id]) : session[:back_to]
	end

	def billing_description billing
		fb = billing&.featured_building
		unless billing.renew_date
			"Featured Building For Four Weeks Starting on #{fb.start_date&.strftime('%b %-d, %Y')}"
		else
			"ID #{fb.id} Renewed Featured Building For Four Weeks Starting on #{(billing.renew_date + 2.day).strftime('%b %-d, %Y')}"
		end
	end
end
