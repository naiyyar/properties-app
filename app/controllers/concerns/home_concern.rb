module HomeConcern
  extend ActiveSupport::Concern
  DEFAULT_LAT = 40.7812
  DEFAULT_LNG = -73.9665

  included do
    before_action :format_search_string,  only: :search
  end

  def search
    searched_by = params[:searched_by]
    if searched_by == 'address'
      @building = Building.find_by(building_street_address: @search_term.strip)
      redirect_to building_path(@building) if @building.present?
    elsif searched_by == 'no-fee-management-companies-nyc' || searched_by == 'management_companies'
      company = ManagementCompany.find_by(name: @search_term.strip)
      redirect_to management_company_path(company) if company.present?
    else
      search_buildings = Buildings::Search.new(params, pop_nb_buildings, @search_string)
      results          = search_buildings.fetch
      @buildings       = @searched_buildings = results[:buildings]
      @boundary_coords = results[:boundary_coords] if results[:boundary_coords].present?
      @zoom            = results[:zoom]            if results[:zoom].present?
      @filters         = results[:filters]
      @tab_title_text  = pop_search_tab_title if @filters.present?
    end

    @featured_listings = FeaturedListing.get_random_objects(@search_string, searched_by, limit: 2)
    @agent = FeaturedAgent.get_random_objects(@search_string, searched_by, limit: 1).first
    
    if @buildings.present?
      @filter_params   = params[:filter]
      @all_buildings, @hash, @per_page_buildings = search_buildings.with_featured_buildings(@buildings, @featured_listings, @agent)
      @lat, @lng       = @hash[0]['latitude'], @hash[0]['longitude']
      @listings_count  = Listing.listings_count(@buildings, @all_buildings, @filter_params)
      @buildings_count = @hash.length rescue 0
    else
      featured_buildings = FeaturedBuilding.active_in_neighborhood(@search_string)
      buildings = pop_nb_buildings.where(id: featured_buildings.pluck(:building_id))
      @hash = Building.buildings_json_hash(buildings)
      @all_buildings = buildings.to_a + @featured_listings.to_a + [@agent].compact
      building = if buildings.present?
                  buildings.first
                else
                  Building.buildings_in_neighborhood(@search_string.downcase).first
                end
      @lat, @lng = building_latlng(building)
    end
    
    @lat, @lng = params[:latitude], params[:longitude] if params[:search_term] == 'custom'
    
    @meta_desc = meta_desc(searched_by)
    @half_footer = true
  end

  private

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
  
  def building_latlng building
    return DEFAULT_LAT, DEFAULT_LNG unless building.present?
    return building.try(:latitude), building.try(:longitude)
  end

  def format_search_string
    @search_term = params[:search_term]
    if @search_term.present?
      terms_arr      =  @search_term.split('-')
      @borough_city  = terms_arr.last
      @search_string = terms_arr.pop
      @search_string = terms_arr.join(' ').titleize
      @search_string = @search_string.gsub('  ', ' -') if @search_string == 'Flatbush   Ditmas Park'
      @search_string = @search_string.gsub(' ', '-')   if @search_string == 'Bedford Stuyvesant'
      @search_string = 'New York'                      if @search_string == 'Newyork'
      
      @borough_city           = (@borough_city == 'newyork' ? 'New York' : @borough_city.capitalize)
      @searched_neighborhoods = "#{@search_string}"
      @search_input_value     = "#{@searched_neighborhoods} - #{@borough_city}, NY"
      @search_input_value     = 'Custom'               if params[:searched_by] == 'latlng'
      @desc_text              = "#{@search_string}"
      @tab_title_text         = "#{@desc_text} #{tab_title_tag}"
    end
  end

end