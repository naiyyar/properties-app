module HomeConcern
  extend ActiveSupport::Concern
  DEFAULT_LAT = 40.7812
  DEFAULT_LNG = -73.9665
  COMPANY_SEARCH_STRINGS = %w(no-fee-management-companies-nyc management_companies)
  
  included do
    before_action :format_search_string, only: :search
  end

  def search
    redirect_to building_path(search_building) if @searched_by == 'address'
    redirect_to management_company_path(search_company) if COMPANY_SEARCH_STRINGS.include?(@searched_by)
    
    # Split View 
    build_instance_variables
    set_tab_title_text
    @hash = buildings_hash # Must be before applying pagination
    searched_buildings = @buildings
    @buildings = pop_nb_buildings.where(id: featured_buildings.pluck(:building_id)) if @buildings.blank?
    @all_buildings = AddFeaturedObjectService.new(@buildings, @search_string, @searched_by).return_buildings
    @buildings = @buildings.paginate(:page => params[:page], :per_page => 20)
    @listings_count = Listing.listings_count(@all_buildings, @filter_params)
    @buildings_count = @hash.length rescue 0
    @lat, @lng = set_latlng
  end

  private

  def search_building
    @building = Building.find_by(building_street_address: @search_term.strip)
  end

  def search_company
    @search_company ||= ManagementCompany.find_by(name: @search_term.strip)
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
      terms_arr = @search_term.split('-')
      @borough_city  = terms_arr.last
      @search_string = terms_arr.pop unless @searched_by == 'nyc'
      @search_string = terms_arr.join(' ').titleize
      @search_string = @search_string.gsub('  ', ' -') if @search_string == 'Flatbush   Ditmas Park'
      @search_string = @search_string.gsub(' ', '-') if @search_string == 'Bedford Stuyvesant'
      @search_string = 'New York' if @search_string == 'Newyork'
      
      @borough_city = (@borough_city == 'newyork' ? 'New York' : @borough_city.capitalize)
      @searched_neighborhoods = "#{@search_string}"
      @search_input_value = "#{@searched_neighborhoods} - #{@borough_city}, NY"
      @search_input_value = 'Custom' if @searched_by == 'latlng'
      @desc_text = "#{@search_string}"
      @tab_title_text = "#{@desc_text} #{tab_title_tag}"
    end
  end

  def first_building
    @buildings.first if @buildings.present?
    Building.buildings_in_neighborhood(@search_string&.downcase).first rescue nil
  end

  def buildings_hash
    Building.buildings_json_hash(@buildings)
  end

  def featured_buildings 
    FeaturedObjectService.new(@search_string).get_buildings
  end

  def build_instance_variables
    @buildings = @searched_buildings = searched_results[:buildings]
    @boundary_coords = searched_results[:boundary_coords] if searched_results[:boundary_coords].present?
    @zoom = searched_results[:zoom] if searched_results[:zoom].present?
    @filters = searched_results[:filters]
    @filter_params = params[:filter]
    @meta_desc = meta_desc(@searched_by)
    @half_footer = true
  end

  def searched_results
    @searched_results ||= Buildings::Search.new(params, pop_nb_buildings, @search_string).fetch
  end

  def set_tab_title_text
    @tab_title_text = pop_search_tab_title if @filters.present?
  end

  def meta_desc searched_by
    unless searched_by == 'nyc'
      "#{@desc_text} has #{@buildings_count.to_i} no fee apartment, no fee rental, 
      for rent by owner buildings in NYC you can rent directly from and pay no broker fees.
      View #{@buildings&.sum(:uploads_count)} photos and #{@buildings&.sum(:reviews_count)} reviews."
    else
      "Browse #{@buildings_count.to_i} No Fee #{pop_search_tab_title}. 
       Bypass the broker and save thousands in fees by renting directly from management companies."
    end
  end

  def pop_search_tab_title
    term = @search_term.split('-').join(' ').titleize
    "#{term.gsub!('Nyc', 'NYC')}"
    return term
  end

end