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
		when 4
			'4+ Bed'
		when -1
			'Room'
		end
	end

	def prices_options
		[
			['$', 1],
			['$$', 2],
			['$$$', 3],
			['$$$$', 4]
		]
	end
end
