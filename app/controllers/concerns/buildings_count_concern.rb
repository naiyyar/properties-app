module BuildingsCountConcern
  extend ActiveSupport::Concern

  included do
    before_action :popular_neighborhoods, if: :show_neighborhoods?
    helper_method :pop_neighborhoods, :pop_nb_buildings
  end

  def popular_neighborhoods
    @pop_nb_hash ||= pop_neighborhoods.group_by(&:name)
  end

  def pop_nb_buildings
    @pop_nb_buildings ||= Building.transparentcity_buildings.select(*Building::ATTRS)
  end

  def pop_neighborhoods
    @pop_neighborhoods ||= Neighborhood.pop_neighborhoods
  end

  protected
  
  def show_neighborhoods?
    view_context.show_filters? || 
    view_context.search_page? || 
    view_context.building_show_page? ||
    view_context.featured_listing_show_page? || 
    view_context.management_show_page? ||
    action_name == 'load_featured_buildings' || 
    action_name == 'saved_buildings' ||
    action_name == 'lazy_load_content'
  end
end