module BillingsHelper
	def brand_name brand=nil
		brand.present? ? brand.downcase.split(' ').join('_') : 'generic'
	end

	def previous_page_path
		unless @object_type == 'FeaturedAgent'
			params[:object_id].present? ? edit_featured_building_path(params[:object_id]) : session[:back_to]
		else
			params[:object_id].present? ? edit_featured_agent_path(params[:object_id]) : session[:back_to]
		end
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
		url = (type == 'FeaturedBuilding' ? 
					managertools_user_path(current_user, type: 'featured') : 
					agenttools_user_path(current_user, type: 'featured'))
		link_to 'Cancel', url, class: 'btn font-bold'
	end
end
