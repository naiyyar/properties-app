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
      @amenities.each do |amenity| 
        @buildings = @buildings.send("#{amenity}")
      end
      @buildings
    end
    
    def filter_by_prices
      return @buildings unless price_filter?
      @buildings.where(price: @price)
    end

    def price_filter?
      @price.present? && !@price.include?('on') && @buildings.present?
    end

    def filter_by_beds
      if @buildings.present?
        buildings = []
        @beds.each{|bed_num | buildings += buildings_by_beds(bed_num) }
      end
      @buildings.where(id: buildings.map(&:id).uniq).uniq rescue nil
    end

    def buildings_by_beds bed_num
      case bed_num
      when '0' then @buildings.studio
      when '1' then @buildings.one_bed
      when '2' then @buildings.two_bed
      when '3' then @buildings.three_bed
      when '5' then @buildings.co_living
      else
        @buildings.four_bed
      end
    end

    def filter_by_listing_prices
      @buildings.between_prices(@min_price.to_i, @max_price.to_i)
    end

    def buildings_with_listing_amenities
      @buildings = @buildings.months_free    if has_amenity?('months_free')
      @buildings = @buildings.owner_paid     if has_amenity?('owner_paid')
      @buildings = @buildings.rent_stabilize if has_amenity?('rent_stabilized')
      @buildings
    end

    def listing_amenity? amenities = nil
      amenities = @amenities || amenities
      return false if amenities.blank?
      amenities.include?('months_free') || amenities.include?('owner_paid') || amenities.include?('rent_stabilized')
    end

    def has_amenity?(name)
      @amenities.include?(name)
    end
  end
end