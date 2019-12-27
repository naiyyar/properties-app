module BillingsHelper

	def brand_name brand=nil
		brand.downcase.split(' ').join('_') if brand.present?
	end
end
