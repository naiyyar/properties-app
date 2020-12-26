module Filter
	class Listings
		def initialize building, load_more_params, listing_type = 'active', filter_params={}
			@listing_type  = listing_type
			@date_active   = load_more_params[:date_active]
			@loaded_ids    = load_more_params[:loaded_ids]
			@building 		 = building
			@listings 		 = listing_type == 'past' ? past_listings : active_listings
			if filter_params.present?
				@amenities  = filter_params[:amenities]
		    @bedrooms  	= filter_params[:listing_bedrooms]
		    @min_price  = filter_params[:min_price].to_i
		    @max_price  = filter_params[:max_price].to_i
		    @max_price  = Listing.max_rent if @max_price == 15500
		  end
		end

		def past_listings
			return @past_listings.where('date_active <= ? AND id not in(?)', @date_active, @loaded_ids) if @date_active.present?
			@building.past_listings
		end

		def active_listings
			@building.listings.active.order_by_rent_asc
		end

		def fetch_listings
			# Not appying filter on featured building listings
			return @listings 													 if @building.featured? && @listing_type != 'past'
			return filtered_listings.order_by_rent_asc if @listing_type != 'past'
	    return @listings.order_by_date_active_desc.limit(PastListing::LIMIT)
	  end

	  def filter_by_beds
	    @bedrooms = @bedrooms.split(' ') unless @bedrooms.kind_of?(Array)
	    @listings.with_beds(@bedrooms.flatten)
	  end

	  def filtered_listings
	    @listings = filter_by_listing_amenities	if @amenities.present?
	    @listings = filter_by_beds 							if @bedrooms.present?
	    @listings = @listings.with_prices(@min_price, @max_price) if @min_price.to_i > 0 || @max_price.to_i > 0
	    return @listings
	  end

	  def filter_by_listing_amenities
	    @amenities = @amenities.split(' ')    unless @amenities.kind_of?(Array)
	    @listings  = @listings.months_free    if @amenities.include?('months_free_rent')
	    @listings  = @listings.owner_paid     if @amenities.include?('owner_paid')
	    @listings  = @listings.rent_stabilize if @amenities.include?('rent_stabilized')
	    return @listings
	  end
	end
end