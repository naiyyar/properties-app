# if @companies.present?
#   json.companies do
#     json.array!(@companies) do |company|
#       json.name company.name
#       json.url management_company_path(company)
#     end
#   end
# end

# if @neighborhoods.present?
#   json.neighborhoods do
#     json.array!(@neighborhoods) do |nb|
#       json.name "#{nb.name}, #{nb.formatted_city}, NY"
#       json.url "/neighborhoods/#{nb.formatted_name}"
#     end
#   end
# end

# if @buildings.present?
#   json.buildings do
#     json.array!(@buildings) do |building|
#       if building.building_name.present?
#         json.name "#{building.building_name} - #{building.building_street_address}, #{building.city}, #{building.state}, #{building.zipcode}"
#       else
#         json.name "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
#       end
#       json.url building_path(building)
#     end
#   end
# end

# if @zipcodes.present?
#   json.zipcodes do
#     json.array!(@zipcodes) do |building|
#       json.name "#{building.zipcode} - #{building.city}, #{building.state}"
#       json.url "/zipcode/#{building.zipcode}-#{building.formatted_city}"
#     end
#   end
# end

# if @city.present?
#   json.city do
#     json.array!(@city) do |building|
#       json.name "#{building.city}, #{building.state}"
#       json.url "/city/#{building.formatted_city}-#{building.state.downcase}"
#     end
#   end
# end

if @companies.present?
  json.array! @companies do |company|
    json.id company.id
    json.search_term "#{company.name}"
    json.url no_fee_company_path(id: company)
    json.category 'Management Company'
    json.search_phrase @search_phrase
  end
end

if @neighborhoods.present?
  json.array! @neighborhoods do |nb|
    json.id nb.id
    json.search_term "#{nb.name}, #{nb.city_name}, NY"
    json.url "/no-fee-apartments-nyc-neighborhoods/#{nb.formatted_name}"
    json.category 'Neighborhood'
    json.search_phrase @search_phrase
  end
end

# if @buildings_by_neighborhood.present?
#   json.array! @buildings_by_neighborhood do |building|
#     json.id building.id
#     if building.neighborhood.present? and !arr.include? building.neighborhood
#       json.search_term "#{building.neighborhood}, #{building.city}, #{building.state}"
#       json.neighborhoods "#{building.formatted_neighborhood}"
#       json.category 'Neighborhood'
#       arr << building.neighborhood
#     end
#   end
# end

if @buildings.present? #and @buildings_by_address.blank? => Removed due to having building name in address
  json.array! @buildings do |building|
    json.id building.id
    if building.building_name.present? and building.building_name != building.building_street_address
      json.search_term "#{building.building_name} - #{building.building_street_address}, #{building.city}, #{building.state}, #{building.zipcode}"
    else
      json.search_term "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
    end
    json.url building_path(building)
    json.category 'Building'
    json.search_phrase @search_phrase
  end
end

# if @buildings_by_address.present?
#   json.array! @buildings_by_address do |building|
#     json.id building.id
#     json.search_term "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
#     json.term_address "#{building.building_street_address}"
#     json.category 'Building'
#   end
# end

if @zipcodes.present?
  json.array! @zipcodes do |building|
    json.id building.id
    json.search_term "#{building.zipcode} - #{building.city}, #{building.state}"
    json.url "/zipcode/#{building.zipcode}-#{building.formatted_city}"
    json.category 'Zipcode'
    json.search_phrase @search_phrase
  end
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
end

# if @search_by_mangement.present?
#   json.array! @search_by_mangement do |company|
#     json.id company.id
#     json.search_term "#{company.name}" #if !arr.include? company.name
#     json.management_company_name "#{company.name}"
#   end
# end

# case @result_type
# when 'no_match_found'
#   json.no_match_found 'No matches found - Add Your Building'
# end
