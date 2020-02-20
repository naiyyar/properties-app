module Filter
	class Listings
		def initialize building, listing_type=nil, listing_filter_params={}
			# listing_filter_params = {"list_amenities"=>"months_free_rent owner_paid", 
			# "list_bedrooms"=>"1 2", "list_min_price"=>"1250", "list_max_price"=>"14500"}
			@listings 				 = building.listings
			@listing_type      = listing_type
			if listing_filter_params.present?
				@amenities 				 = listing_filter_params[:list_amenities]
		    @bedrooms 				 = listing_filter_params[:list_bedrooms]
		    @min_price 				 = listing_filter_params[:list_min_price].to_i
		    @max_price 				 = listing_filter_params[:list_max_price].to_i
		    @max_price 				 = 30000 if @max_price == 15500
		  end
		end

		def show_more_listings
			unless @listing_type.present?
	      filtered_listings.order_by_date_active_desc
	    else
	      filtered_listings.active.order_by_rent_asc
	    end
	  end

	  def filtered_listings
	    @listings = filter_by_listing_amenities 													if @amenities.present?
	    @listings = @listings.with_beds(@bedrooms.split(' ').map(&:to_i)) if @bedrooms.present?
	    @listings = @listings.with_prices(@min_price, @max_price) 				if @min_price.present?
	    return @listings
	  end

	  def filter_by_listing_amenities
	    amenities = @amenities.split(' ')
	    @listings = @listings.months_free    if amenities.include?('months_free_rent')
	    @listings = @listings.owner_paid     if amenities.include?('owner_paid')
	    @listings = @listings.rent_stabilize if amenities.include?('rent_stabilized')
	    return @listings
	  end
	end
end