class RentMedian < ApplicationRecord

	def self.rent_price type_val, prices
    price_rec(type_val, prices).price
  end

  def self.price_rec type_val, prices
  	prices.find_by(bed_type: type_val)
  end

  def self.rent_medians price
  	where(range: price)
  end
end
