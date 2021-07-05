module BillingsHelper
	def brand_name brand=nil
		brand.present? ? brand.downcase.split(' ').join('_') : 'generic'
	end

	def previous_page_path object, object_type
		return session[:back_to] if payment_object_id.present?
		if object_type == 'FeaturedBuilding'
			!object.featured_by_manager? ? featured_buildings_path : managertools_user_path(current_user, type: 'featured')
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
end
