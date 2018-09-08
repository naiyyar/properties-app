class Neighborhood < ActiveRecord::Base

	def nb_name_with_counts
		"#{name} (#{buildings_count})"
	end

	def self.save_building_counts boroughs, borough_neighborhoods
		boroughs.each do |borough|
      neighborhoods = Neighborhood.where(boroughs: borough)
      if neighborhoods.blank?
        borough_neighborhoods[borough].each do |hoods|
          Neighborhood.create(name: hoods, buildings_count: Building.number_of_buildings(hoods), boroughs: borough)
        end
      end
    end
	end

end
