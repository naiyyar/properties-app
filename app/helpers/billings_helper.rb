module BillingsHelper
	def brand_name brand=nil
		brand.present? ? brand.downcase.split(' ').join('_') : 'generic'
	end

	def previous_page_path
		params[:fb_id].present? ? edit_featured_building_path(params[:fb_id]) : session[:back_to]
	end
end
