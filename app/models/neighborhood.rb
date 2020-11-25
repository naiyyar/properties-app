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
  include PgSearch::Model

  validates :name, presence: true
  validates_uniqueness_of :name, scope: [:boroughs], on: :create, message: 'Duplicate name.'
  
  pg_search_scope :nb_search, against: [:name],
     :using => { :tsearch => { prefix: true } }

  def nb_name_with_counts
    "#{name} (#{buildings_count})"
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

  def self.nb_buildings_count hoods, name
    Rails.cache.fetch([self, name, 'hoods_count']) {
      hoods.where(name: name).sum(:buildings_count) 
    }
  end

  def self.cached_nb_buildings_count name
    nb_buildings_count(name)
  end

  def self.pop_neighborhoods
    self.select(:id, :name, :buildings_count)
  end

end
