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
		else
			'4+ Bed'
		end
	end
end
