module Search
  module BuildingFilters
    def filtered_buildings buildings, filter_params
      @price      = filter_params[:price]
      @beds       = filter_params[:bedrooms]
      @min_price  = filter_params[:min_price] 
      @amenities  = filter_params[:amenities]
      @buildings  = buildings
      # building filters
      @buildings = filter_by_amenities if @amenities.present? && has_building_amenities?
      @buildings = filter_by_prices    if @price.present? && @min_price.blank?
      @buildings = filter_by_beds      if @beds.present?
      
      # listings filters
      listings_filters = filter_params[:listings]
      if listings_filters.present?
        listing_beds = listings_filters[:listing_bedrooms]
        @max_price   = listings_filters[:max_price]
        @buildings   = @buildings.with_active_listing.join_with_listings
        @buildings   = @buildings.with_listings_bed(listing_beds) if listing_beds.present?
        @buildings   = filter_by_listing_prices                   if @min_price.present? && @max_price.present?
        @buildings   = buildings_with_listing_amenities           if listing_amenity?
      end 
      @buildings
    end

    def has_building_amenities?
      (Building::AMENITIES & @amenities.map(&:to_sym)).present?
    end

    def filter_by_amenities
      return @buildings unless @amenities.present?
      @buildings = @buildings.doorman           if has_amenity?('doorman')
      @buildings = @buildings.courtyard         if has_amenity?('courtyard')
      @buildings = @buildings.laundry_facility  if has_amenity?('laundry_facility')
      @buildings = @buildings.gym               if has_amenity?('gym')
      @buildings = @buildings.parking           if has_amenity?('parking')
      @buildings = @buildings.roof_deck         if has_amenity?('roof_deck')
      @buildings = @buildings.pets_allowed_cats if has_amenity?('pets_allowed_cats')
      @buildings = @buildings.pets_allowed_dogs if has_amenity?('pets_allowed_dogs')
      @buildings = @buildings.elevator          if has_amenity?('elevator')
      @buildings = @buildings.swimming_pool     if has_amenity?('swimming_pool')
      @buildings = @buildings.walk_up           if has_amenity?('walk_up')
      @buildings = @buildings.no_fee            if has_amenity?('no_fee')
      @buildings = @buildings.live_in_super     if has_amenity?('live_in_super')
      @buildings
    end

    # def filter_by_amenities buildings, amenities
    #   return buildings unless amenities.present?
    #   @buildings = buildings
    #   amenities.each(&:to_sym).each do |amenity|
    #     @buildings = @buildings.where(amenity => true)
    #   end
    #   @buildings
    # end
    
    def filter_by_prices
      return @buildings unless @price.present? && !@price.include?('on') && @buildings.present?
      @buildings.where(price: @price)
    end

    def filter_by_beds
      if @buildings.present?
        buildings = []
        @beds.each do |num|
          if num == '0'
            buildings += @buildings.studio
          elsif num == '1'
            buildings += @buildings.one_bed
          elsif num == '2'
            buildings += @buildings.two_bed
          elsif num == '3'
            buildings += @buildings.three_bed
          elsif num == '5'
            buildings += @buildings.co_living
          else
            buildings += @buildings.four_bed
          end
        end
      end
      @buildings.where(id: buildings.map(&:id).uniq).uniq rescue nil
    end

    def filter_by_listing_prices
      @max_price = Listing.max_rent if @max_price.to_i == 15500
      @buildings.between_prices(@min_price.to_i, @max_price.to_i)
    end

    def buildings_with_listing_amenities
      @buildings = @buildings.months_free    if has_amenity?('months_free_rent')
      @buildings = @buildings.owner_paid     if has_amenity?('owner_paid')
      @buildings = @buildings.rent_stabilize if has_amenity?('rent_stabilized')
      @buildings
    end

    def listing_amenity? amenities = nil
      amenities = @amenities || amenities
      return false if amenities.blank?
      amenities.include?('months_free_rent') || amenities.include?('owner_paid') || amenities.include?('rent_stabilized')
    end

    def has_amenity?(name)
      @amenities.include?(name)
    end
  end
end