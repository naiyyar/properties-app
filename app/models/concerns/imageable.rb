module Imageable
	extend ActiveSupport::Concern
	included do
		has_many :uploads, as: :imageable
		accepts_nested_attributes_for :uploads, :allow_destroy => true
	end
end