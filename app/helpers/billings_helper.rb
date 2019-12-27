module BillingsHelper
	def brand_name brand=nil
		brand.present? ? brand.downcase.split(' ').join('_') : 'generic'
	end
end
