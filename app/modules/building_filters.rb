module BuildingFilters
	# def filter_by_rates buildings, rating
  #   # 1 star - means  = 1
  #   # 2 star - means  1 <= 2
  #   # 3 star - means  2 <= 3
  #   # 4 star - means  3 <= 4
  #   # 5 star - means  4 <= 5 
  #   if rating.present?
  #     rates = RatingCache.where(cacheable_type: 'Building')
  #     if rating == '1'
  #       rates = rates.where('avg = ?', rating)
  #     else
  #       rates = rates.where('avg > ? AND avg <= ?', rating.to_i-1, rating)
  #     end
  #     buildings.where('id in (?)', rates.map(&:cacheable_id))
  #   else
  #     buildings
  #   end
  # end

  def filter_by_prices buildings, price
    if price.present? and !price.include?('on')
      buildings = buildings.where(price: price) if buildings.exists?
    else
      buildings = buildings
    end
  end

  def filter_by_beds buildings, beds
    if buildings.exists?
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
    if buildings.exists?
      buildings = buildings_with_active_listings(buildings)
      filtered_buildings = []
      beds.each do |num|
        if num == '0'
          filtered_buildings += buildings.l_studio
        elsif num == '1'
          filtered_buildings += buildings.l_one_bed
        elsif num == '2'
          filtered_buildings += buildings.l_two_bed
        elsif num == '3'
          filtered_buildings += buildings.l_three_bed
        else
          filtered_buildings += buildings.l_four_bed
        end
      end
    end
    buildings.where(id: filtered_buildings.map(&:id).uniq).uniq rescue nil
  end

  def filter_by_listing_prices buildings, min_price, max_price
    if buildings.exists?
      buildings = buildings_with_active_listings(buildings).uniq
      #when listing have price more than 15500
      #assuming listing max price can be upto 30000
      max_price = max_price.to_i == 15500 ? 30000 : max_price
      buildings.where('listings.rent >= ? AND listings.rent <= ?', min_price.to_i, max_price.to_i)
    end
  end

  # def filter_by_types buildings, type
  #   if type.present?
  #     buildings = buildings.where(building_type: type)
  #   else
  #     buildings = buildings
  #   end
  # end

  def filter_by_amenities buildings, amenities
    @amenities = amenities
    if amenities.present?
      @buildings = buildings
      @buildings = @buildings.doorman if has_amenity?('doorman')
      @buildings = @buildings.courtyard if has_amenity?('courtyard')
      @buildings = @buildings.laundry_facility if has_amenity?('laundry_facility')
      @buildings = @buildings.parking if has_amenity?('parking')
      @buildings = @buildings.gym if has_amenity?('gym')
      @buildings = @buildings.garage if has_amenity?('garage')
      @buildings = @buildings.management_company_run if has_amenity?('management_company_run')
      @buildings = @buildings.live_in_super if has_amenity?('live_in_super')
      @buildings = @buildings.roof_deck if has_amenity?('roof_deck')
      @buildings = @buildings.pets_allowed_cats if has_amenity?('pets_allowed_cats')
      @buildings = @buildings.pets_allowed_dogs if has_amenity?('pets_allowed_dogs')
      @buildings = @buildings.elevator if has_amenity?('elevator')
      @buildings = @buildings.swimming_pool if has_amenity?('swimming_pool')
      @buildings = @buildings.childrens_playroom if has_amenity?('childrens_playroom')
      @buildings = @buildings.walk_up if has_amenity?('walk_up')
      @buildings = @buildings.no_fee if has_amenity?('no_fee')
      #for listings
      if @amenities.include?('months_free_rent') || @amenities.include?('owner_paid') || @amenities.include?('rent_stabilized')
        @buildings = buildings_with_listing_amenities
      end
    else
      @buildings = buildings
    end
    @buildings
  end

  def has_amenity?(name)
    @amenities.include?(name)
  end

  def buildings_with_listing_amenities
    @buildings = buildings_with_active_listings(@buildings)
    @buildings = @buildings.where('listings.free_months > ?', 0) if has_amenity?('months_free_rent')
    @buildings = @buildings.where('listings.owner_paid is not null') if has_amenity?('owner_paid')
    @buildings = @buildings.where('listings.rent_stabilize = ?', 'true') if has_amenity?('rent_stabilized')
    return @buildings.uniq
  end

  def filtered_buildings buildings, filter_params
    #rating = filter_params[:rating]
    #building_types = filter_params[:type]
    price = filter_params[:price]
    beds = filter_params[:bedrooms]
    listing_beds = filter_params[:listing_bedrooms]
    amenities = filter_params[:amenities]
    min_price = filter_params[:min_price]
    max_price = filter_params[:max_price]

    buildings = filter_by_amenities(buildings, amenities) if amenities.present?
    #buildings = filter_by_rates(buildings, rating) if rating.present?
    buildings = filter_by_prices(buildings, price) if price.present? and min_price.blank?
    buildings = filter_by_beds(buildings, beds) if beds.present?
    buildings = filter_by_listing_beds(buildings, listing_beds) if listing_beds.present?
    buildings = filter_by_listing_prices(buildings, min_price, max_price) if min_price.present? and max_price.present?
    #buildings = filter_by_types(buildings, building_types) if building_types.present?
    return buildings
  end
end