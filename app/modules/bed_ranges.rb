module BedRanges
	def bedroom_ranges(filter_params=nil)
    building_beds = [studio, one_bed, two_bed, three_bed, four_plus_bed, co_living].compact
    return building_beds unless min_and_max_price?
    get_listings_beds(filter_params)
  end

  def get_listings_beds filter_params
    listings = act_listings.present? ? act_listings : self.get_listings(filter_params)
    return listings&.pluck(:bed).uniq.compact.sort
  end

  def show_bed_ranges(filter_params)
    beds = []
    bedroom_ranges(filter_params).map do |bed|
      beds << (bed == 0 ? 'Studio' : bed) unless bed == 5
    end
    beds
  end

  def price_ranges filters=nil
    ranges = {}
    prices = Price.where(range: price)
    bedroom_ranges(filters).each{|bed_range| ranges[bed_range] = prices.find_by(bed_type: bed_range)}
    return ranges
  end

  def has_only_studio? filters
    show_bed_range = show_bed_ranges(filters)
		return show_bed_range.length == 1 && show_bed_range[0] == 'Studio'
	end

  def coliving_with_building_beds?
		!listings_beds? && co_living == 5
	end

  def listings_beds?
    min_and_max_price?
  end

  def bedroom_types?
    studio.present? || either_of_four? || listings_beds?
  end
  
  def either_of_two?
    three_bed.present? || four_plus_bed.present?
  end
  
  def either_of_three?
    either_of_two? || two_bed.present?
  end
  
  def either_of_four?
    either_of_three? || one_bed.present?
  end
end