module Tourable
	extend ActiveSupport::Concern

	included do
		has_many :video_tours, as: :tourable, dependent: :destroy
		accepts_nested_attributes_for :video_tours, :allow_destroy => true
	end

end