module PricesHelper
	def bedroom_type bed_type
		case bed_type
		when 0
			'Studio'
		when 1
			'1 Bed'
		when 2
			'2 Bed'
		when 3
			'3 Bed'
		when 5
			'CoLiving'
		else
			'4+ Bed'
		end
	end

	def prices_options
		@prices_options ||= [
			['$', 1],
			['$$', 2],
			['$$$', 3],
			['$$$$', 4]
		]
	end
end
