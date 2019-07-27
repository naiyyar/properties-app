if @buildings.present?
	json.array!(@buildings) do |building|
	  json.(building, :id,:building_name, :building_street_address, :city, :state, :zipcode)
	 	json.search_type @search_type
	 	json.building_address building.full_street_address
	 	json.address building.building_street_address
	 	json.management_company building.management_company.try(:name)
	 	json.featured_search_type @feature_comp_search_type
	  json.units building.units do |unit|
	    json.(unit, :id, :name, :square_feet, :number_of_bedrooms, :number_of_bathrooms)
	  end
	end
else
	json.no_match_found 'No matches found'
end
