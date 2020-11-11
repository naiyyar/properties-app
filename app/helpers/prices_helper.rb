module PricesHelper
	def bedroom_type bed_type
		if bed_type == 0
			'Studio'
		elsif bed_type == 1 || bed_type == 2 || bed_type == 3
			"#{bed_type} Bed"
		elsif bed_type >= 4 && bed_type != Building::COLIVING_NUM
			'4+ Bed'
		elsif bed_type == Building::COLIVING_NUM
			'CoLiving'
		elsif bed_type < 0
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
