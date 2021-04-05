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
				@bedrooms = bedroom_filters
				@amenities = amenities_filters
		    @min_price, @max_price = min_max_prices
		    @max_price  = Listing::MAX_RENT if @max_price.to_i == 15500
		  end
		end

		def fetch_listings
			# Not appying filter on featured building listings
			return @listings if @building.featured? && @listing_type != 'past'
			return filtered_listings.order_by_rent_asc if @listing_type != 'past'
	    @listings.order_by_date_active_desc.limit(PastListing::LIMIT)
	  end

	  private

	  def bedroom_filters
	  	return listing_beds if listing_beds.kind_of?(Array)
		  listing_beds.split(' ') unless listing_beds.blank?
	  end

	  def amenities_filters
	  	return listing_amenities if listing_amenities.kind_of?(Array)
			listing_amenities.split(' ') unless listing_amenities.blank?
	  end

	  def listings_params
	  	@listings_params ||= @filter_params[:listings]
	  end

	  def min_max_prices
	  	return @filter_params[:min_price].to_i, @filter_params[:max_price].to_i unless listings_params.present?
	  	[listings_params[:min_price], listings_params[:max_price]]
	  end

	  def listing_amenities
			return @filter_params[:amenities] unless listings_params.present?
			listings_params[:amenities]
	  end

	  def listing_beds
	  	return @filter_params[:listing_bedrooms] unless listings_params.present?
	  	return listings_params[:listing_bedrooms].values unless listings_params[:listing_bedrooms].kind_of?(Array)
			listings_params[:listing_bedrooms]
		end

		def past_listings
			past_listings = @building.past_listings
			return past_listings unless @date_active.present?
			past_listings.where('date_active <= ? AND id not in(?)', @date_active, @loaded_ids)
		end

		def active_listings
			@building.listings.order_by_rent_asc
		end

	  def filtered_listings
	    @listings = filter_by_listing_amenities	if @amenities.present?
	    @listings = filter_by_beds if @bedrooms.present?
	    @listings = between_prices if @min_price.to_i > 0 || @max_price.to_i > 0
	    @listings
	  end

	  def filter_by_listing_amenities
	  	return @listings unless listing_amenities?
	    @amenities.map{ |amenity| @listings.send("#{amenity}") }[0]
	  end

	  def listing_amenities?
	  	(@amenities & Listing::AMENITIES.keys.map(&:to_s)).present?
	  end

	  def filter_by_beds
	    @listings.with_beds(@bedrooms.flatten)
	  end

	  def between_prices
	  	@listings.between_prices(@min_price, @max_price)
	  end
	end
end