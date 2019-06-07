class RentMedian < ActiveRecord::Base

	def self.rent_price type_val, prices
    price_rec(type_val, prices).price
  end

  def self.price_rec type_val, prices
  	prices.find_by(bed_type: type_val)
  end
end
