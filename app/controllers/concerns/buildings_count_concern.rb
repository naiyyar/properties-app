module BuildingsCountConcern
  extend ActiveSupport::Concern

  included do
    before_action :popular_neighborhoods, if: :show_neighborhoods?
    helper_method :pop_neighborhoods, :pop_nb_buildings
  end

  def popular_neighborhoods
    @pop_hash ||= pop_neighborhoods.group_by(&:name)
  end

  def pop_nb_buildings
    @pop_buildings ||= Building.app_buildings
  end

  def pop_neighborhoods
    @pop_neighborhoods ||= Neighborhood.pop_neighborhoods
  end

  protected
  
  def show_neighborhoods?
    helpers.search_page? || helpers.building_show_page? || helpers.management_show_page? ||
  end
end