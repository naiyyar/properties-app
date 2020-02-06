module BillingsHelper
	def brand_name brand=nil
		brand.present? ? brand.downcase.split(' ').join('_') : 'generic'
	end

	def previous_page_path
		params[:fb_id].present? ? edit_featured_building_path(params[:fb_id]) : session[:back_to]
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
