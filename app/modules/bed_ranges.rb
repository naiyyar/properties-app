module BedRanges
  def bedroom_ranges(filter_params=nil)
    unless min_and_max_price?
      return building_beds, 'building'
    else
      return get_listings_beds(filter_params), 'listing'
    end
  end

  def building_beds
    [co_living, studio, one_bed, two_bed, three_bed, four_plus_bed].compact
  end

  def get_listings_beds filter_params
    listings = act_listings.present? ? act_listings : self.get_listings(filter_params)
    return listings&.pluck(:bed).uniq.compact.sort
  end

  def show_bed_ranges(filter_params)
    beds = []
    bed_ranges, modal_type = bedroom_ranges(filter_params)
    bed_ranges.map do |bed|
      beds << set_bed_type(bed, modal_type)
      # beds << (bed == 0 ? 'Studio' : bed) unless bed == 5
    end
    beds
  end

  def set_bed_type bed, modal_type
    if bed == -1
      'Room'
    elsif bed == 0
      'Studio'
    elsif bed == Building::COLIVING_NUM && modal_type == 'building'
      'CoLiving'
    else
      bed
    end
  end

  def price_ranges filters=nil
    ranges                 = {}
    prices                 = Price.where(range: price)
    bed_ranges, modal_type = bedroom_ranges(filters)
    bed_ranges.each do |bed_range|
      bdr               = bed_range
      bdr               = Building::COLIVING_NUM if bed_range == -1 && modal_type == 'listing'
      ranges[bed_range] = prices.find_by(bed_type: bdr)
    end
    return ranges
  end

  def rent_median_prices
    range = bedroom_ranges[0]
    if range.include?(-1)
      range = range.map{|x| x == -1 ? Building::COLIVING_NUM : x }
    end
    return rent_medians.where(range: price, bed_type: range)
  end

  def broker_fee_savings
    saved_amounts = {}
    rent_median_prices.as_json.each do |mp| 
      saved_amounts[mp['bed_type']] = (((mp['price'].to_i * 12) * broker_percent)/100).to_i
    end
    saved_amounts
  end

  def broker_percent
    BrokerFeePercent.first.percent_amount
  end

  def rent_medians
    @rent_medians ||= RentMedian.all
  end

  def min_and_max_price?
    min_listing_price.present? && max_listing_price.present?
  end

  def min_save_amount
    broker_fee_savings.values.min
  end

  def has_only_studio? filters
    show_bed_range = show_bed_ranges(filters)
    return show_bed_range.length == 1 && show_bed_range[0] == 'Studio'
  end

  def has_only_room? filters
    show_bed_range = show_bed_ranges(filters)
    return show_bed_range.length == 1 && show_bed_range[0] == 'Room'
  end

  def coliving_with_building_beds?
    !listings_beds? && coliving
  end

  def listings_beds?
    min_and_max_price?
  end

  def bedroom_types?
    studio.present? || either_of_four? || listings_beds? || coliving
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

  def coliving
    co_living == Building::COLIVING_NUM
  end
end