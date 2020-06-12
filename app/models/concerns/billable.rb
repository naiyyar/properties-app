module Billable
	extend ActiveSupport::Concern
	included do
		has_many :billings, as: :billable
	end

	# def get_billings
 #    billings.includes(:billable)
 #  end
end