module SearchConcern
  extend ActiveSupport::Concern
  DEFAULT_LAT = 40.7812
  DEFAULT_LNG = -73.9665
  COMPANY_SEARCH_STRINGS = %w(no-fee-management-companies-nyc management_companies).freeze

  included do
    before_action :format_search_string, only: :search
  end

  def search
    redirect_to building_path(search_building) if @searched_by == 'address'
    redirect_to management_company_path(search_company) if COMPANY_SEARCH_STRINGS.include?(@searched_by)
    
    @buildings = SearchService.new(params, pop_nb_buildings, @search_string).fetch
    searched_buildings = @buildings
    @pagy, @buildings = pagy(@buildings)
    @all_buildings = AddFeaturedObjectService.new(@buildings, searched_buildings, @search_string, @searched_by).return_buildings
    @hash = Building.buildings_json_hash(searched_buildings) # To display map markers
    @buildings_count = @hash.length
    @lat, @lng = set_latlng
  end

  private

  def display_featured_buildings
    pop_nb_buildings.where(id: featured_buildings&.pluck(:building_id))
  end

  def search_building
    @building = Building.find_by(building_street_address: @search_term.strip)
  end

  def search_company
    ManagementCompany.find_by(name: @search_term.strip)
  end
  
  def set_latlng
    return custom_search_latlng if params[:search_term] == 'custom'
    return DEFAULT_LAT, DEFAULT_LNG unless first_building.present?
    return first_building.try(:latitude), first_building.try(:longitude)
  end

  def custom_search_latlng
    [params[:latitude], params[:longitude]]
  end

  def format_search_string
    @search_term = params[:search_term]
    @searched_by = params[:searched_by]
    if @search_term.present?
      @search_string = @search_term.split('-').join(' ').titleize
    end
  end

  def first_building
    return @buildings.first if @buildings.present?
    Building.buildings_in_neighborhood(@search_string&.downcase).first rescue nil
  end

end