module BillingsHelper

	def brand_name brand=nil
		debugger
		brand.downcase.split(' ').join('_') if brand.present?
	end
end
