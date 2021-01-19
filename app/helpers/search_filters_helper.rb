class String
	def remove_blanks
		self.downcase.gsub(' ', '-')
	end
end

module SearchFiltersHelper
	# To retain filters when switching neighborhoods
	# /no-fee-apartments-nyc-neighborhoods/lower-manhattan-newyork?sort_by=4&filter%5Bprice%5D%5B%5D=2&searched_by=no-fee-apartments-nyc-neighborhoods
	def search_link neighborhood, borough
		unless borough == 'BRONX'
			search_url = search_url(neighborhood, borough)
			if sort_by.present? and params[:filter].present?
				"#{search_url}?sort_by=#{sort_by}&#{filter_params}"
			elsif sort_by.present?
				"#{search_url}?sort_by=#{sort_by}"
			elsif params[:filter].present?
				"#{search_url}"
			else
				filter_params.present? ? "#{search_url}?#{filter_params}" : "#{search_url}"
			end
		else
			'javascript:void(0)'
		end
	end

	def search_url neighborhood, borough
		borough = (borough == 'MANHATTAN' ? 'newyork' : borough.remove_blanks)
		return "/no-fee-apartments-nyc-neighborhoods/#{neighborhood.remove_blanks}-#{borough}"	
	end

	def sort_by
		sort_by ||= params[:sort_by]
	end

	def filter_params
		params[:filter].present? ? params[:filter].to_query('filter') : nil
	end

	def listings_filters
		return {} if params[:filter].blank?
		@listings_filters ||= params[:filter][:listings]
	end

	def bed_checked val
		if params[:filter].present? && params[:filter][:bedrooms].present?
			params[:filter][:bedrooms].include?(val) ? 'checked' : ''
		elsif @filters.present? && @filters[:beds].present?
			@filters[:beds].include?(val) ? 'checked' : ''
		end
	end

	def price_checked val
		if params[:filter].present? && params[:filter][:price].present?
			params[:filter][:price].include?(val.to_s) ? 'checked' : ''
		elsif @filters.present? && @filters[:price].present?
			@filters[:price].include?(val) ? 'checked' : ''
		end
	end

	def listing_bed_checked val
		if listings_filters.present? && listings_filters[:listing_bedrooms].present?
			listings_filters[:listing_bedrooms].include?(val.to_s) ? 'checked' : ''
		elsif @filters.present? &&  @filters[:listing_bedrooms].present?
			@filters[:listing_bedrooms].include?(val) ? 'checked' : ''
		end
	end

	def listing_price_box_checked
		'checked' if listings_filters && listings_filters[:min_price].present?
	end

	def amen_checked val
		if params[:filter].present? && params[:filter][:amenities].present?
			params[:filter][:amenities].include?(val) ? 'checked' : ''
		elsif @filters.present? &&  @filters[:amenities].present?
			@filters[:amenities].include?(val) ? 'checked' : ''
		end
	end

	def listings_amen_checked val
		if listings_filters.present? && listings_filters[:amenities].present?
			listings_filters[:amenities].include?(val) ? 'checked' : ''
		elsif @filters.present? &&  @filters[:amenities].present?
			@filters[:amenities].include?(val) ? 'checked' : ''
		end
	end

	def amen_locked? val
		if @filters.present? && @filters[:amenities].present?
			@filters[:amenities].include?(val) ? 'disabled' : ''
		else
			''
		end
	end

	def bed_locked? val
		(@filters.present? && @filters[:beds].present? && @filters[:beds].include?(val)) ? 'disabled' : ''
	end

	def price_locked? val
		(@filters.present? && @filters[:price].present? && @filters[:price].include?(val)) ? 'disabled' : ''
	end
end