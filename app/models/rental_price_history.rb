class RentalPriceHistory < ActiveRecord::Base
	belongs_to :unit

	validate :residence_end_date_after_residence_start_date?

	def residence_end_date_after_residence_start_date?
	  if residence_end_date < residence_start_date
	    errors.add :residence_end_date, 'Must be after resident from'
	  end
	end
end
