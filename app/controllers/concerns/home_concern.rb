module HomeConcern
  extend ActiveSupport::Concern

  def search
    searched_by = params[:searched_by]
    if searched_by == 'address'
      @building = Building.find_by(building_street_address: @search_term.strip)
      redirect_to building_path(@building) if @building.present?
    elsif searched_by == 'no-fee-management-companies-nyc'
      company = ManagementCompany.find_by(name: @search_term.strip)
      redirect_to management_company_path(company) if company.present?
    else
      results          = Buildings::Search.new(params, @search_string, pop_nb_buildings).fetch
      @buildings       = @searched_buildings = results[:buildings]
      @boundary_coords = results[:boundary_coords] if results[:boundary_coords].present?
      @zoom            = results[:zoom]            if results[:zoom].present?
      @filters         = results[:filters]
      @tab_title_text  = Building.pop_search_tab_title(@search_term) if @filters.present?
    end
    
    if @buildings.present?
      @filter_params      = params[:filter]
      page_num            = params[:page].present? ? params[:page].to_i : 1
      search_terms        = [@search_string, searched_by]
      final_results       = Building.with_featured_building(@buildings, search_terms, params[:sort_by], @filter_params, page_num)
      @per_page_buildings = final_results[1]
      @all_buildings      = final_results[0][:all_buildings] # with featured
      @hash               = final_results[0][:map_hash]
      @lat, @lng          = @hash[0]['latitude'], @hash[0]['longitude']
      @listings_count     = Listing.listings_count(@buildings, @all_buildings, @filter_params)
      @buildings_count    = @hash.length rescue 0
    end
    
    @agents    = FeaturedAgent.get_random_agent(@search_string, searched_by)
    @meta_desc = Building.meta_desc(@buildings, searched_by, desc:  @desc_text, 
                                                             count: @buildings_count, 
                                                             term:  @search_term)
    @half_footer = true
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