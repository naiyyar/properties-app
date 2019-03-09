class FeaturedCompBuilding < ActiveRecord::Base
	belongs_to :building
	belongs_to :featured_comp
end