module Amenitable
	extend ActiveSupport::Concern
	included do
		has_many :amenities, as: :amenitable
		accepts_nested_attributes_for :amenities, :allow_destroy => true
	end
end