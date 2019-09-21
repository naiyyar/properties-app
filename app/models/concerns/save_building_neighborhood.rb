module SaveBuildingNeighborhood
	extend ActiveSupport::Concern
	included do
		after_create :save_neighborhood, :update_neighborhood_counts
  	after_update :update_neighborhood, :update_neighborhood_counts, :if => Proc.new{ |obj| obj.continue_call_back? }
  	after_destroy :update_neighborhood_counts
	end

	def continue_call_back?
    !(avg_rating_changed? && recommended_percent_changed? && min_listing_price_changed? && max_listing_price_changed?)
  end

	private

  #child neighbohoods
  def predifined_neighborhoods
    arr = []
    File.open("#{Rails.root}/public/neighborhoods.txt", "r").each_line do |line|
      arr << line.split(/\n/)
    end
    nyc_neighborhoods = arr.flatten.uniq
    nyc_neighborhoods << ApplicationController.helpers.queens_borough
    nyc_neighborhoods << ApplicationController.helpers.bronx_borough
    return  nyc_neighborhoods.flatten.sort
  end

  def just_parent_neighborhoods
    ['Harlem']
  end

  #Parent neighbohoods
  def parent_neighborhoods
    [ 'Midtown East','Midtown North',
      'Midtown South','Midtown West','Upper West Side',
      'Upper East Side','Lower East Side',
      'Greenwich Village','Flatbush - Ditmas Park'
    ]
  end

  def grandparent_neighborhoods
    ['Lower Manhattan', 'Upper Manhattan', 'Midtown']
  end

  #saving neighbohoods
  def neighborhoods
    search = Geocoder.search([latitude, longitude])
    if search.present? and first_neighborhood.blank?
      neighborhood1 = neighborhood2 = neighborhood3 = ''
      #search for child neighborhoods
      search[0..7].each_with_index do |geo_result, index|
        #finding neighborhood
        neighborhood = geo_result.address_components_of_type(:neighborhood)
        if neighborhood.present?
          neighborhood = neighborhood.first['long_name']
          sublocality = search[0].address_components_of_type(:sublocality)
          if sublocality.present?
            locality = sublocality.first['long_name']
          else
            locality = search[0].address_components_of_type(:locality).first['long_name']
          end
          #checking main neighborhood
          if ['Queens','Brooklyn','Bronx'].include?(locality) and self.city == neighborhood
            neighborhood1 = neighborhood
          elsif predifined_neighborhoods.include? neighborhood
            neighborhood1 = neighborhood if neighborhood1.blank?
          elsif just_parent_neighborhoods.include? neighborhood
            neighborhood2 = neighborhood
          elsif parent_neighborhoods.include? neighborhood #checking parent of main neighborhood
            neighborhood2 = neighborhood if neighborhood2.blank?
            neighborhood1 = neighborhood if neighborhood1.blank? and index >= 2
          elsif grandparent_neighborhoods.include? neighborhood #checking grandparent of main neighborhood
            neighborhood3 = neighborhood
            neighborhood2 = neighborhood if neighborhood2.blank? and neighborhood1.blank?
          else
            neighborhood1 = neighborhood if neighborhood1.blank?
            parent_neighborhood = 'East Village'
            neighborhood2 = parent_neighborhood
          end
          #discontinue once neighborhood is saved
          break
        end
      end #end search loop
    else
      neighborhood3 = self.neighborhood3
      if ['Alphabet City','Ukrainian Village'].include?(self.neighborhood)
        neighborhood1 = 'East Village'
        neighborhood2 = 'Lower Manhattan'
      elsif self.neighborhood == 'East Village'
        neighborhood1 = self.neighborhood
        neighborhood2 = 'Lower Manhattan'
      elsif ['Rose Hill'].include?(self.neighborhood)
        neighborhood1 = 'Kips Bay'
        neighborhood3 = 'Midtown'
      elsif ['Bloomingdale'].include?(self.neighborhood)
        neighborhood1 = 'Upper West Side'
      else
        neighborhood1 = self.neighborhood
        neighborhood2 = parent_neighborhood
      end
    end #end search if

    return neighborhood1, neighborhood2, neighborhood3
  end

  def parent_neighborhood
    if self.neighborhoods_parent.present?
      return self.neighborhoods_parent
    else
      buildings = Building.where('neighborhoods_parent is not null and neighborhood = ?', self.neighborhood)
      return buildings.present? ? buildings.first.neighborhoods_parent : nil
    end
  end

  def save_neighborhood
    if neighborhoods.present?
      self.neighborhood = neighborhoods[0]
      self.neighborhoods_parent = neighborhoods[1]
      self.neighborhood3 = neighborhoods[2]
      self.save
    end
  end

  def update_neighborhood
    if neighborhoods.present?
      self.update_columns(neighborhood: neighborhoods[0], neighborhoods_parent: neighborhoods[1], neighborhood3: neighborhoods[2])
    end
  end

  def update_neighborhood_counts
    popular_neighborhoods.each do |hood|
      if hood.buildings_count.to_i >= 0
        hood.buildings_count = Building.buildings_in_neighborhood(hood.name, hood.boroughs).count
        hood.save
      end
    end
  end
end