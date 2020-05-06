module Search
  module BuildingFilters
    LISTING_AMENITIES = %w(months_free_rent owner_paid rent_stabilized)
    
    def filter_by_prices buildings, price
      return buildings unless price.present? && !price.include?('on') && buildings.present?
      buildings.where(price: price)
    end

    def filter_by_beds buildings, beds
      if buildings.present?
        @buildings = []
        beds.each do |num|
          if num == '0'
            @buildings += buildings.studio
          elsif num == '1'
            @buildings += buildings.one_bed
          elsif num == '2'
            @buildings += buildings.two_bed
          elsif num == '3'
            @buildings += buildings.three_bed
          else
            @buildings += buildings.four_bed
          end
        end
      end
      buildings.where(id: @buildings.map(&:id).uniq).uniq rescue nil
    end

    def filter_by_listing_beds buildings, beds
      if buildings.present?
        buildings_with_beds = buildings.with_listings_bed(beds)
        ids = buildings_with_beds.pluck(:id).uniq
        return buildings_with_beds.distinct if ids.empty?
        transparentcity_buildings.order_by_id_pos(ids)
      end
    end

    def filter_by_listing_prices buildings, min_price, max_price
      if buildings.present?
        # when listing have price more than 15500
        # assuming listing max price can be upto whatever maximum rent listing table has
        max_price = Listing.max_rent if max_price.to_i == 15500
        buildings_with_prices = buildings.between_prices(min_price.to_i, max_price.to_i)
        ids = buildings_with_prices.map(&:id).uniq
        return buildings_with_prices.distinct if ids.empty?
        transparentcity_buildings.order_by_id_pos(ids)
      end
    end

    def filter_by_amenities buildings, amenities
      @amenities = amenities
      if amenities.present?
        @buildings = buildings
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
        
        # for listings
        @buildings = buildings_with_listing_amenities(@buildings) if listing_amenity?(@amenities)
      else
        @buildings = buildings
      end
      @buildings
    end

    def buildings_with_listing_amenities buildings
      buildings = buildings.where('listings.free_months > ?', 0)         if has_amenity?('months_free_rent')
      buildings = buildings.where('listings.owner_paid is not null')     if has_amenity?('owner_paid')
      buildings = buildings.where('listings.rent_stabilize = ?', 'true') if has_amenity?('rent_stabilized')
      
      return buildings.uniq
    end

    def filtered_buildings buildings, filter_params
      price                = filter_params[:price]
      beds                 = filter_params[:bedrooms]
      listing_beds         = filter_params[:listing_bedrooms]
      amenities            = filter_params[:amenities]
      min_price, max_price = filter_params[:min_price], filter_params[:max_price]
      #
      buildings = buildings.with_active_listing
      buildings = filter_by_amenities(buildings, amenities)                 if amenities.present?
      buildings = filter_by_prices(buildings, price)                        if price.present? && min_price.blank?
      buildings = filter_by_beds(buildings, beds)                           if beds.present?
      buildings = buildings.with_active_listing.joins(:listings)            if filtered_by_listings?(filter_params)
      if listing_beds.present?
        buildings = filter_by_listing_beds(buildings, listing_beds)           
        buildings = buildings.joins(:listings) 
      end
      buildings = filter_by_listing_prices(buildings, min_price, max_price) if min_price.present? && max_price.present?
      return buildings
    end

    def filtered_by_listings? filter
      filter[:listing_bedrooms].present? || filter[:max_price].present? || listing_amenity?(filter[:amenities])
    end

    def listing_amenity? amenities
      return false if amenities.blank?
      amenities.include?('months_free_rent') || amenities.include?('owner_paid') || amenities.include?('rent_stabilized')
    end

    def has_amenity?(name)
      @amenities.include?(name)
    end
  end
end