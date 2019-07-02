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

class Neighborhood < ApplicationRecord

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
    return "#{name.downcase.gsub(' ', '-')}-#{formatted_city.downcase}"
  end

  def formatted_city
    city = boroughs.titleize
    city = 'New York' if city == 'Manhattan'
    city.gsub(' ', '')
  end

  def city_name
    city = boroughs.titleize
    city = 'New York' if city == 'Manhattan'
    city.gsub('', '')
  end

  def self.nb_buildings_count name
    where(name: name).sum(:buildings_count)
  end

  def self.cached_nb_buildings_count name
    Rails.cache.fetch([self, 'cached_nb_buildings_count', name]) { nb_buildings_count(name) }
  end

  # def self.nb_borough(nb, area)
  #   Rails.cache.fetch([self, nb]) { where(name: nb, boroughs: area.upcase) }
  # end

end
