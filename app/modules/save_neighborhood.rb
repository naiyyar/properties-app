module SaveNeighborhood
	def parent_neighborhoods
    [ 'Midtown East','Midtown North',
      'Midtown South','Midtown West','Upper West Side',
      'Upper East Side','Lower East Side',
      'Greenwich Village','Flatbush - Ditmas Park'
    ]
  end

  def level3_neighborhoods
    ['Lower Manhattan', 'Upper Manhattan', 'Midtown']
  end
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
  
  #saving neighbohoods
  def get_and_save_neighborhood mode=''
  	if mode != 'manually'
	    search = Geocoder.search([latitude, longitude])
	    if search.present?
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
	          save_neighborhood(neighborhood) if neighborhood.present?
	        end
	      end
	    end
    end
  end

  def save_neighborhood hood
  	hood = 'Midtown' if hood == 'Midtown Manhattan'
    self.neighborhood = hood if predifined_neighborhoods.include?(hood)
    building_with_nb3 = Building.select(:neighborhood, :neighborhoods_parent, :neighborhood3)
                                .where(neighborhood: neighborhood)
                                .where.not(neighborhoods_parent: [nil], neighborhood3: [nil]).first
    if building_with_nb3.present?
      self.neighborhoods_parent = building_with_nb3.neighborhoods_parent 
      self.neighborhood3 = building_with_nb3.neighborhood3
    else
      self.neighborhoods_parent = hood if parent_neighborhoods.include?(hood)
      self.neighborhood3 = hood if level3_neighborhoods.include?(hood)
    end
    self.save
  end
end