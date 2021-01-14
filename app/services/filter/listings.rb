module Filter
	class Listings
		def initialize building, load_more_params, listing_type = 'active', filter_params={}
			@listing_type  = listing_type
			@date_active   = load_more_params[:date_active]
			@loaded_ids    = load_more_params[:loaded_ids]
			@building 		 = building
			@listings 		 = listing_type == 'past' ? past_listings : active_listings
			@filter_params = filter_params
			
			if @filter_params.present?
				@amenities  = listing_amenities
		    @bedrooms  	= listing_beds
		    @min_price, @max_price = min_max_prices
		    @max_price  = Listing.max_rent if @max_price == 15500
		  end
		end

		def fetch_listings
			# Not appying filter on featured building listings
			return @listings 													 if @building.featured? && @listing_type != 'past'
			return filtered_listings.order_by_rent_asc if @listing_type != 'past'
	    return @listings.order_by_date_active_desc.limit(PastListing::LIMIT)
	  end

	  private

	  def listings_params
	  	@listings_params ||= @filter_params[:listings]
	  end

	  def min_max_prices
	  	return @filter_params[:min_price], @filter_params[:max_price] unless listings_params.present?
	  	[listings_params[:min_price], listings_params[:max_price]]
	  end

	  def listing_amenities
			return @filter_params[:amenities] unless listings_params.present?
			listings_params[:amenities]
	  end

	  def listing_beds
	  	return @filter_params[:listing_bedrooms] unless listings_params.present?
			listings_params[:listing_bedrooms]
		end

		def past_listings
			past_listings = @building.past_listings
			return past_listings unless @date_active.present?
			past_listings.where('date_active <= ? AND id not in(?)', @date_active, @loaded_ids)
		end

		def active_listings
			@building.listings.active.order_by_rent_asc
		end

	  def filter_by_beds
	    @bedrooms = @bedrooms.split(' ') unless @bedrooms.kind_of?(Array)
	    @listings.with_beds(@bedrooms.flatten)
	  end

	  def filtered_listings
	    @listings = filter_by_listing_amenities	if @amenities.present?
	    @listings = filter_by_beds 							if @bedrooms.present?
	    @listings = @listings.between_prices(@min_price, @max_price) if @min_price.to_i > 0 || @max_price.to_i > 0
	    @listings
	  end

	  def filter_by_listing_amenities
	    @amenities = @amenities.split(' ')    unless @amenities.kind_of?(Array)
	    @listings  = @listings.months_free    if @amenities.include?('months_free_rent')
	    @listings  = @listings.owner_paid     if @amenities.include?('owner_paid')
	    @listings  = @listings.rent_stabilize if @amenities.include?('rent_stabilized')
	    @listings
	  end
	end
end