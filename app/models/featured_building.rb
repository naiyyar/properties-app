class FeaturedBuilding < ActiveRecord::Base
	belongs_to :featured_comp
	belongs_to :building
end
