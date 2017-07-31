class RentalPriceHistory < ActiveRecord::Base
	belongs_to :unit

	# validate :residence_end_date_after_residence_start_date?

	# def residence_end_date_after_residence_start_date?
	# 	if residence_end_date.present? and residence_start_date.present?
	# 	  if residence_end_date < residence_start_date
	# 	    errors.add :residence_end_date, 'Must be after resident from'
	# 	  end
	# 	end
	# end

	def res_start_year
		self.residence_start_date.present? ? self.residence_start_date.strftime("%Y") : self.start_year
	end

	def res_end_year
		self.residence_end_date.present? ? self.residence_end_date.strftime("%Y") : self.end_year
	end
end
