module BillingsHelper
	def brand_name brand=nil
		brand.present? ? brand.downcase.split(' ').join('_') : 'generic'
	end

	def previous_page_path object, object_type
		return session[:back_to] if payment_object_id.present?
		
		if object_type == 'FeaturedAgent'
			edit_featured_agent_path(payment_object_id)
		elsif object_type == 'FeaturedBuilding'
			edit_featured_building_path(payment_object_id)
		elsif object_type == 'FeaturedListing'
			next_prev_step_url(object, step: 'add_photos')
		end
	end

	def payment_object_id
		@payment_object_id ||= params[:object_id]
	end

	def card_brand_image brand
		image_tag "card_brands/#{brand_name(brand)}.svg", height: 20
	end

	def status_text billing
		billing.payment_failed? ? 
		'<b class="text-danger"> Failed</b>' :
		'<b class="text-success"> Successful</b>'
	end

	def cancel_form_link type
		link_to 'Cancel', redirect_url(type), class: 'cancel btn btn-default font-bold'
	end

	def redirect_url type
		case type
		when 'FeaturedBuilding'
			managertools_user_path(current_user, type: 'featured')
		when 'FeaturedAgent'
			agenttools_user_path(current_user, type: 'featured')
		when 'FeaturedListing'
			frbotools_user_path(current_user, type: 'featured')
		end
	end
end
