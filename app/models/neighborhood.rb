# == Schema Information
#
# Table name: neighborhoods
#
#  id              :integer          not null, primary key
#  name            :string
#  boroughs        :string
#  buildings_count :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Neighborhood < ActiveRecord::Base

  include PgSearch
  pg_search_scope :nb_search, against: [:name],
     :using => { :tsearch => { prefix: true } }

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

  def formatted_name
    return "#{name.downcase.gsub(' ', '-')}-#{formatted_city}"
  end

  def formatted_city
    city = boroughs.capitalize
    city = 'New York' if city == 'Manhattan'
    city.gsub('', '')
  end

end
