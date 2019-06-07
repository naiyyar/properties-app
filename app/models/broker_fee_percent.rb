class BrokerFeePercent < ActiveRecord::Base
	validates :percent_amount, numericality: { greater_than: 0 }

end
