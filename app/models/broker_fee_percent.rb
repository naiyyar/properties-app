class BrokerFeePercent < ActiveRecord::Base
	validates :percent_amount, numericality: { greater_than: 0 }

	after_update :clear_buildings_cache

	private
	def clear_buildings_cache
		Rails.cache.clear()
	end

end
