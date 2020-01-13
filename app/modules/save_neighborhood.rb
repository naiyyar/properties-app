module SaveNeighborhood
	def parent_neighborhoods
    [ 'Midtown East','Midtown North',
      'Midtown South','Midtown West','Upper West Side',
      'Upper East Side','Lower East Side',
      'Greenwich Village','Flatbush - Ditmas Park', 'Harlem'
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
	          nb_name = neighborhood.first['long_name']
	          save_neighborhood(nb_name) if nb_name.present?
	        end
	      end
	    end
    end
  end

  def save_neighborhood hood
  	hood      = 'Midtown' if hood == 'Midtown Manhattan'
    nb        = hood      if predifined_neighborhoods.include?(hood)
    nb_parent = hood      if parent_neighborhoods.include?(hood)
    nb3       = hood      if level3_neighborhoods.include?(hood)
    if nb == 'Ukrainian Village'
      nb  = 'East Village'
      nb3 = nb_parent = 'Lower Manhattan'
    end
    update_column(:neighborhood, nb)                if nb.present? and neighborhood.blank?
    update_column(:neighborhoods_parent, nb_parent) if nb_parent.present? and neighborhoods_parent.blank?
    update_column(:neighborhood3, nb3)              if nb3.present? and neighborhood3.blank?
  end

  # def building_with_nb3 neighborhood
  #   Building.select(:id, :neighborhood, :neighborhoods_parent, :neighborhood3)
  #           .where.not(neighborhood: nil, neighborhoods_parent: [nil], neighborhood3: [nil])
  #           .where(neighborhood: neighborhood).first
  # end
end