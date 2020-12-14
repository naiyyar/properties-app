module BuildingsCountConcern
  extend ActiveSupport::Concern

  included do
    before_action :popular_neighborhoods
    helper_method :uptown_count, :brooklyn_count, :queens_count, :bronx_count
  end

  def popular_neighborhoods
    @pop_nb_hash ||= pop_neighborhoods.group_by(&:name)
  end

  def uptown_count
    @uptown_count ||= Neighborhood.nb_buildings_count(pop_neighborhoods, NYCBorough.uptown_sub_borough)
  end

  def brooklyn_count
    @brooklyn_count ||= Building.city_count(pop_nb_buildings,'Brooklyn', NYCBorough.brooklyn_sub_borough)
  end

  def queens_count
    @queens_count ||= Building.city_count(pop_nb_buildings,'Queens', NYCBorough.queens_borough)
  end

  def bronx_count
    @bronx_count ||= Building.city_count(pop_nb_buildings, 'Bronx', NYCBorough.bronx_sub_borough)
  end

  def pop_nb_buildings
    @pop_nb_buildings ||= Building.transparentcity_buildings.select(*Building::ATTRS)
  end

  def pop_neighborhoods
    @pop_neighborhoods ||= Neighborhood.pop_neighborhoods
  end

  protected
  def show_neighborhoods?
    home_page? || show_filters? || search_page? || building_show_page? || management_show_page?
  end
end