class String
	def remove_blanks
		self.downcase.gsub(' ', '-')
	end
end

module SearchFiltersHelper
	# To retain filters when switching neighborhoods
	# /no-fee-apartments-nyc-neighborhoods/lower-manhattan-newyork?sort_by=4&filter%5Bprice%5D%5B%5D=2&searched_by=no-fee-apartments-nyc-neighborhoods
	def search_link neighborhood, borough
		return 'javascript:void(0)' if borough == 'BRONX'
		search_url = search_url(neighborhood, borough)
		return "#{search_url}?sort_by=#{sort_by}&#{filter_params}" if sort_and_filter_params?
		return "#{search_url}?sort_by=#{sort_by}" if sort_by.present? && sort_by != '0'
		return "#{search_url}?#{filter_params}" if filter_params.present?
		search_url
	end

	def search_url neighborhood, borough
		"/no-fee-apartments-nyc-neighborhoods/#{neighborhood.remove_blanks}-#{borough_city(borough)}"
	end

	def sort_by
		params[:sort_by]
	end

	def filter_params
		return unless permitted_filter_params[:filter].present?
		permitted_filter_params[:filter].to_query('filter')
	end

	def listings_filters
		return {} if params[:filter].blank?
		params[:filter][:listings]
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

	private

	def borough_city borough
		(borough == 'MANHATTAN' ? 'newyork' : borough.remove_blanks)
	end

	def sort_and_filter_params?
		sort_by.present? && params[:filter].present?
	end

	def permitted_filter_params
		params.permit!
	end
end