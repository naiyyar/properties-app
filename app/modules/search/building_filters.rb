module Search
  module BuildingFilters
    def filter_by_prices buildings, price
      if price.present? && !price.include?('on') && buildings.present?
        buildings.where(price: price)
      else
        buildings
      end
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
      buildings.with_listings_bed(beds).distinct if buildings.present?
    end

    def filter_by_listing_prices buildings, min_price, max_price
      if buildings.present?
        # when listing have price more than 15500
        # assuming listing max price can be upto 30000
        max_price = 30000 if max_price.to_i == 15500
        buildings.between_prices(min_price.to_i, max_price.to_i).distinct
      end
    end

    def filter_by_amenities buildings, amenities
      @amenities = amenities
      if amenities.present?
        @buildings = buildings
        @buildings = @buildings.doorman                       if has_amenity?('doorman')
        @buildings = @buildings.courtyard                     if has_amenity?('courtyard')
        @buildings = @buildings.laundry_facility              if has_amenity?('laundry_facility')
        @buildings = @buildings.gym                           if has_amenity?('gym')
        @buildings = @buildings.parking                       if has_amenity?('parking')
        @buildings = @buildings.roof_deck                     if has_amenity?('roof_deck')
        @buildings = @buildings.pets_allowed_cats             if has_amenity?('pets_allowed_cats')
        @buildings = @buildings.pets_allowed_dogs             if has_amenity?('pets_allowed_dogs')
        @buildings = @buildings.elevator                      if has_amenity?('elevator')
        @buildings = @buildings.swimming_pool                 if has_amenity?('swimming_pool')
        @buildings = @buildings.walk_up                       if has_amenity?('walk_up')
        @buildings = @buildings.no_fee                        if has_amenity?('no_fee')
        @buildings = @buildings.live_in_super                 if has_amenity?('live_in_super')
        
        # for listings
        if listing_amenity?
          @buildings = buildings_with_listing_amenities
        end
      else
        @buildings = buildings
      end
      @buildings
    end

    def listing_amenity?
      @amenities.include?('months_free_rent') || @amenities.include?('owner_paid') || @amenities.include?('rent_stabilized')
    end

    def has_amenity?(name)
      @amenities.include?(name)
    end

    def buildings_with_listing_amenities
      @buildings = buildings_with_active_listings(@buildings)
      @buildings = @buildings.where('listings.free_months > ?', 0)          if has_amenity?('months_free_rent')
      @buildings = @buildings.where('listings.owner_paid is not null')      if has_amenity?('owner_paid')
      @buildings = @buildings.where('listings.rent_stabilize = ?', 'true')  if has_amenity?('rent_stabilized')
      return @buildings.uniq
    end

    def filtered_buildings buildings, filter_params
      price                = filter_params[:price]
      beds                 = filter_params[:bedrooms]
      listing_beds         = filter_params[:listing_bedrooms]
      amenities            = filter_params[:amenities]
      min_price, max_price = filter_params[:min_price], filter_params[:max_price]
      
      buildings = buildings_with_active_listings(buildings)                 if filtered_by_listings?(filter_params)
      buildings = filter_by_amenities(buildings, amenities)                 if amenities.present?
      buildings = filter_by_prices(buildings, price)                        if price.present? && min_price.blank?
      buildings = filter_by_beds(buildings, beds)                           if beds.present?
      buildings = filter_by_listing_beds(buildings, listing_beds)           if listing_beds.present?
      buildings = filter_by_listing_prices(buildings, min_price, max_price) if min_price.present? && max_price.present?
      return buildings
    end

    def filtered_by_listings? filter
      filter[:listing_bedrooms].present? || filter[:max_price].present?
    end
  end
end