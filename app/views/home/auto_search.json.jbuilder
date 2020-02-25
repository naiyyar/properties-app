if @companies.present?
  json.array! @companies do |company|
    json.id company.id
    json.search_term "#{company.name}"
    json.url no_fee_company_path(id: company)
    json.category 'Management Company'
    json.search_phrase @search_phrase
  end
  @no_match_found = false
end

if @neighborhoods.present?
  json.array! @neighborhoods do |nb|
    json.id nb.id
    json.search_term "#{nb.name}, #{nb.city_name}, NY"
    json.url "/no-fee-apartments-nyc-neighborhoods/#{nb.formatted_name}"
    json.category 'Neighborhood'
    json.search_phrase @search_phrase
  end
  @no_match_found = false
end

if @buildings.present? #and @buildings_by_address.blank? => Removed due to having building name in address
  json.array! @buildings do |building|
    json.id building.id
    if building.building_name.present? && building.building_name != building.building_street_address
      json.search_term "#{building.building_name} - #{building.full_street_address}"
    else
      json.search_term "#{building.full_street_address}"
    end
    json.url building_path(building)
    json.category 'Building'
    json.search_phrase @search_phrase
  end
  @no_match_found = false
end

if @zipcodes.present?
  json.array! @zipcodes do |building|
    json.id building.id
    json.search_term "#{building.zipcode} - #{building.city}, #{building.state}"
    json.url "/zipcode/#{building.zipcode}-#{building.formatted_city}"
    json.category 'Zipcode'
    json.search_phrase @search_phrase
  end
  @no_match_found = false
end

if @city.present?
  json.array! @city do |building|
    json.id building.id
    #condition because if city name and neighborhood name is same then search will have duplicates items
    json.search_term "#{building.city}, #{building.state}"
    json.url "/no-fee-apartments-nyc-city/#{building.formatted_city}-#{building.state.downcase.gsub(' ','')}"
    json.category 'City'
    json.search_phrase @search_phrase
  end
  @no_match_found = false
end

json.no_match_found 'No matches found' if @no_match_found
