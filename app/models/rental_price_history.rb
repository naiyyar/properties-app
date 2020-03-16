# == Schema Information
#
# Table name: rental_price_histories
#
#  id                   :integer          not null, primary key
#  residence_start_date :date
#  residence_end_date   :date
#  monthly_rent         :decimal(, )      default(0.0)
#  broker_fee           :decimal(, )      default(0.0)
#  non_refundable_costs :decimal(, )      default(0.0)
#  rent_upfront         :decimal(, )      default(0.0)
#  refundable_deposits  :decimal(, )      default(0.0)
#  unit_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  start_year           :string
#  end_year             :string
#

class RentalPriceHistory < ApplicationRecord
	belongs_to :unit

	def res_start_year
		residence_start_date.present? ? residence_start_date.strftime('%Y') : start_year
	end

	def res_end_year
		residence_end_date.present? ? residence_end_date.strftime('%Y') : end_year
	end
end
