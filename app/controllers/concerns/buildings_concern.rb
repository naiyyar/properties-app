module BuildingsConcern
  extend ActiveSupport::Concern

  def show
    @show_map_btn = @half_footer = true
    @distance_results = DistanceMatrix.get_data(@building) if Rails.env == 'production'
    broker_percent = BrokerFeePercent.first.percent_amount
    @saved_amounts = @building.saved_amount(RentMedian.all, broker_percent)
    @building_price = @building.price
    @rating_cache = @building.rating_cache?
    @price_ranges = {}
    prices = Price.where(range: @building_price)
    @building.bedroom_ranges.each do |bed_range|
      @price_ranges[bed_range] = prices.find_by(bed_type: bed_range)
    end
    #building + units images
    @uploads = @building.chached_image_uploads
    @uploaded_images_count = @uploads.count
    @documents = @building.doc_uploads
    @reviews_count = @building.reviews_count.to_i

    #Similiar buildings
    @similar_properties = Building.where(id: @building.active_comps.pluck(:building_id)).includes(:building_average, :featured_building) if @building.active_comps.present?
    
    @lat = @building.latitude
    @lng = @building.longitude

    buildings = @similar_properties.to_a + [@building]
    @gmaphash = Building.buildings_json_hash(buildings)
    @listings = @building.listings
    @active_listings = @listings.active.reorder(rent: :asc)
    @all_inactive_listings = @listings.inactive
    @inactive_listings = @all_inactive_listings.reorder(date_active: :desc, rent: :asc).limit(5)

    @meta_desc = "#{@building.building_name if @building.building_name.present? } "+ 
                  "#{@building.building_street_address} is a #{@building.building_type if @building.building_type.present?} "+ 
                  "in #{@building.neighbohoods} #{@building.city} and is managed by #{@building.management_company.name if @building.management_company.present? }. "+ 
                  "Click to view #{@uploaded_images_count} photos and #{@reviews_count} reviews"
    
    flash[:notice] = "Files are uploaded successfully." if params[:from_uploaded].present?
  end

  def create
    if current_user.nil?
      # Store the form data in the session so we can retrieve it after login
      session[:form_data] = params
      session[:object_type] = params[:unit_contribution].present? ? 'unit' : 'building'
      # Redirect the user to register/login
      redirect_to new_user_registration_path
    else
      if params[:building][:building_street_address].present? and params[:building][:zipcode].present?
        @building = Building.find_by_building_street_address_and_zipcode(params[:building][:building_street_address], params[:building][:zipcode])
      elsif params[:building][:building_street_address].present?
        @building = Building.find_by_building_street_address(params[:building][:building_street_address])
      else
        @building = Building.find_by_building_street_address(params['buildings-search-txt'])
      end
      if @building.blank?
        @building = Building.create(building_params)

        if @building.save
          
          if params[:unit_contribution]
            contribute = params[:unit_contribution]
            unit_id = @building.units.last.id
          else
            contribute = params[:contribution]
            #building_id = @building.id
          end
          flash[:notice] = "Building Created."
          if contribute.present?
            if ['unit_review', 'unit_photos', 'unit_amenities', 'unit_price_history'].include? contribute
              redirect_to contribute_buildings_path(contribution_for: contribute, building_id: @building.id, contribution: contribute)  
            else
              redirect_to user_steps_path(building_id: @building.id, unit_id: unit_id, contribution_for: contribute, contribution: contribute)
            end
          else
            redirect_to building_steps_path(building_id: @building.id)
          end
          
        else
          flash.now[:error] = "Error Creating"
          render :new
        end
      else
        if params[:unit_id].present?
          @unit = Unit.find(params[:unit_id])
          @unit.update(unit_params)
        else
          if params[:building][:units_attributes].present?
            @unit = @building.fetch_or_create_unit(building_params)
          end
        end
        if params[:unit_contribution]
          contribute = params[:unit_contribution]
          unit_id = @unit.id
        else
          contribute = params[:contribution]
          building_id = @building.id
        end
        if params[:page].present?
          redirect_to unit_path(@unit)
        else
          redirect_to user_steps_path(building_id: @building.id, unit_id: unit_id, contribution_for: contribute)
        end
      end
    end
  end

  private
  #Parent neighbohoods
  def parent_neighborhoods
    [ 'Midtown East','Midtown North',
      'Midtown South','Midtown West','Upper West Side',
      'Upper East Side','Lower East Side',
      'Greenwich Village','Flatbush - Ditmas Park'
    ]
  end

  def level3_neighborhoods
    ['Lower Manhattan', 'Upper Manhattan', 'Midtown']
  end
  #child neighbohoods
  def predifined_neighborhoods
    arr = []
    File.open("#{Rails.root}/public/neighborhoods.txt", "r").each_line do |line|
      arr << line.split(/\n/)
    end
    nyc_neighborhoods = arr.flatten.uniq
    nyc_neighborhoods << view_context.queens_borough
    nyc_neighborhoods << view_context.bronx_borough
    return  nyc_neighborhoods.flatten.sort
  end
  
  #saving neighbohoods
  def get_neighborhood
  	if params[:selected_manually] != 'manually'
	    search = Geocoder.search([@building.latitude, @building.longitude])
	    if search.present?
	      neighborhood1 = neighborhood2 = neighborhood3 = ''
	      #search for child neighborhoods
	      search[0..7].each_with_index do |geo_result, index|
	        #finding neighborhood
	        neighborhood = geo_result.address_components_of_type(:neighborhood)
	        if neighborhood.present?
	          neighborhood = neighborhood.first['long_name']
	          sublocality = search[0].address_components_of_type(:sublocality)
	          if sublocality.present?
	            locality = sublocality.first['long_name']
	          else
	            locality = search[0].address_components_of_type(:locality).first['long_name']
	          end
	          save_neighborhood(neighborhood) if neighborhood.present?
	        end
	      end
	    end
    end
  end

  def save_neighborhood hood
  	hood = 'Midtown' if hood == 'Midtown Manhattan'
    @building.neighborhood = hood if predifined_neighborhoods.include?(hood)
    building_with_nb3 = Building.select(:neighborhood, :neighborhoods_parent, :neighborhood3)
                                .where(neighborhood: @building.neighborhood)
                                .where.not(neighborhoods_parent: nil, neighborhood3: nil).first
    if building_with_nb3.present?
      @building.update(neighborhoods_parent: building_with_nb3.first.neighborhoods_parent, neighborhood3: building_with_nb3.first.neighborhood3)
    else
      @building.neighborhoods_parent = hood if parent_neighborhoods.include?(hood)
      @building.neighborhood3 = hood if level3_neighborhoods.include?(hood)
      @building.save
    end
  end

end