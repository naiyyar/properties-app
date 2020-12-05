class Price < ApplicationRecord

	def self.min_price type_val, prices
    price_rec(type_val, prices)&.min_price
  end

  def self.max_price type_val, prices
    price_rec(type_val, prices)&.max_price
  end

  def self.price_rec type_val, prices
  	prices.find_by(bed_type: type_val)
  end

end
