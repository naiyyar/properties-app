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
        @amenities   = listings_filters[:amenities]
        @max_price   = listings_filters[:max_price].to_i
        @max_price   = Listing.max_rent if @max_price == 15500
        @min_price   = listings_filters[:min_price]
        @buildings   = @buildings.with_active_listing.join_with_listings
        @buildings   = @buildings.with_listings_bed(listing_beds) if listing_beds.present?
        @buildings   = filter_by_listing_prices                   if @min_price.present? && @max_price.present?
        @buildings   = buildings_with_listing_amenities           if listing_amenity?
      end 
      @buildings
    end

    private
    
    def has_building_amenities?
      (Building::AMENITIES & @amenities.map(&:to_sym)).present?
    end

    def filter_by_amenities
      return @buildings unless @amenities.present?
      @buildings.with_amenities(@amenities)
    end
    
    def filter_by_prices
      return @buildings unless price_filter?
      @buildings.where(price: @price)
    end

    def price_filter?
      @price.present? && !@price.include?('on') && @buildings.present?
    end

    def filter_by_beds
      @buildings.with_bed(@beds) rescue nil
    end

    def filter_by_listing_prices
      @buildings.between_prices(@min_price.to_i, @max_price.to_i)
    end

    def buildings_with_listing_amenities
      @buildings = @buildings.months_free    if has_amenity?('months_free')
      @buildings = @buildings.owner_paid     if has_amenity?('owner_paid')
      @buildings = @buildings.rent_stabilize if has_amenity?('rent_stabilize')
      @buildings
    end

    def listing_amenity? amenities = nil
      amenities = @amenities || amenities
      return false if amenities.blank?
      (Listing::AMENITIES.keys.map(&:to_s) & amenities).present?
    end

    def has_amenity?(name)
      @amenities.include?(name)
    end
  end
end