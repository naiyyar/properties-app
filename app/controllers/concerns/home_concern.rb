module HomeConcern
  extend ActiveSupport::Concern

  def search
    results = Building.apt_search(params, @search_string, @sub_borough)
    if results[:searched_by] == 'address'
      @building = results[:building]
      redirect_to building_path(@building.first) if @building.present?
    elsif results[:searched_by] == 'no-fee-management-companies-nyc'
      redirect_to management_company_path(results[:company].first) if results[:company].present?
    else
      @buildings       = @searched_buildings = results[:buildings]
      @boundary_coords = results[:boundary_coords] if results[:boundary_coords].present?
      @zoom            = results[:zoom]            if results[:zoom].present?
      @filters         = results[:filters]
      @tab_title_text  = pop_search_tab_title      if @filters.present?
    end
    
    if @buildings.present?
      @buildings          = @buildings.includes(:building_average, :featured_buildings)
      page_num            = params[:page].present? ? params[:page].to_i : 1
      final_results       = Building.with_featured_building(@buildings, page_num)
      @per_page_buildings = final_results[1]
      @all_buildings      = final_results[0][:all_buildings] #with featured
      @hash               = final_results[0][:map_hash]
      @lat, @lng          = @hash[0]['latitude'], @hash[0]['longitude']
      @listings_count     = Listing.listings_count(@buildings, params[:filter])
      @buildings_count    = @buildings&.size
      @photos_count       = @buildings.sum(:uploads_count)
      @reviews_count      = @buildings.sum(:reviews_count)
    else
      @lat, @lng = latlng
    end

    unless params[:searched_by] == 'nyc'
      @meta_desc = "#{@meta_desc_text} has #{@buildings_count.to_i} "+ 
                   "no fee apartment, no fee rental, for rent by owner buildings in NYC you can rent directly from and pay no broker fees. "+ 
                   "View #{@photos_count} photos and #{@reviews_count} reviews."
    else
      @meta_desc = "Browse #{@buildings_count.to_i} No Fee #{pop_search_tab_title}. Bypass the broker and save thousands in fees by renting directly from management companies."
    end
  end

  def latlng
    if @boundary_coords.present? && @boundary_coords.first.length > 1
      @lat = @boundary_coords.first.first[:lat]
      @lng = @boundary_coords.first.first[:lng]
    else
      if @searched_buildings.present?
        @lat = @searched_buildings.first.latitude
        @lng = @searched_buildings.first.longitude
      elsif @building.present?
        @lat = @building.first.latitude
        @lng = @building.first.longitude
      else
        @lat = params[:latitude].to_f
        @lng = params[:longitude].to_f
      end
    end
    return @lat, @lng
  end

  def format_search_string
    if params['search_term'].present?
      terms_arr      =  params['search_term'].split('-')
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
      @meta_desc_text         = "#{@search_string} #{@borough_city}"
      @tab_title_text         = "#{@meta_desc_text} #{tab_title_tag}"

      if !searched_params.include?(params[:searched_by])
        @sub_borough             = {}
        @sub_borough['Queens']   = view_context.queens_sub_borough
        @sub_borough['Brooklyn'] = view_context.brooklyn_sub_borough
        @sub_borough['Bronx']    = view_context.bronx_sub_borough
      end
    end
    @half_footer = true
  end

  def searched_params
    ['address', 'no-fee-management-companies-nyc', 'zipcodes']
  end

  def pop_search_tab_title
    term = params[:search_term].split('-').join(' ').titleize
    "#{term.gsub!('Nyc', 'NYC')}"
  end

end