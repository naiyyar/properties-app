# if @companies.present?
#   json.companies do
#     json.array!(@companies) do |company|
#       json.name company.name
#       json.url "/management_company/#{company.name}"
#     end
#   end
# end

#if @neighborhoods.present?
  json.neighborhoods do
    json.array!(@pneighborhoods) do |building|
      json.name "#{building.neighborhoods_parent}, #{building.city}, #{building.state}"
      json.url "/neighborhoods/#{building.formatted_neighborhood('parent')}"
    end
  end

  json.neighborhoodss do
    json.array!(@neighborhoods) do |building|
      json.name "#{building.neighborhoods_parent}, #{building.city}, #{building.state}"
      json.url "/neighborhoods/#{building.formatted_neighborhood}"
    end
  end
#end

# json.buildings do
#   json.array!(@buildings) do |building|
#     if building.building_name.present?
#       json.search_term "#{building.building_name} - #{building.building_street_address}, #{building.city}, #{building.state}, #{building.zipcode}"
#     else
#       json.search_term "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
#     end
#     json.url building_path(building)
#   end
# end

# json.zipcodes do
#   json.array!(@zipcodes) do |building|
#     json.name "#{building.zipcode} - #{building.city}, #{building.state}"
#     json.url "/zipcode/#{building.zipcode}"
#   end
# end

# json.city do
#   json.array!(@city) do |city|
#     json.name director.name
#     json.url director_path(director)
#   end
# end

# arr = []
# if @search_by_mangement.present?
#   json.array! @search_by_mangement do |company|
#     json.id company.id
#     json.search_term "#{company.name}" #if !arr.include? company.name
#     json.management_company_name "#{company.name}"
#     json.category 'Management Company'
#   end
# end

# if @buildings_by_pneighborhood.present?
#   json.array! @buildings_by_pneighborhood do |building|
#     json.id building.id
#     json.search_term "#{building.neighborhoods_parent}, #{building.city}, #{building.state}"
#     json.neighborhoods "#{building.formatted_neighborhood('parent')}"
#     json.category 'Neighborhood'
#     arr << building.neighborhoods_parent
#   end
# end

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

# if @buildings_by_name.present? #and @buildings_by_address.blank? => Removed due to having building name in address
#   json.array! @buildings_by_name do |building|
#     json.id building.id
#     if building.building_name.present?
#       json.search_term "#{building.building_name} - #{building.building_street_address}, #{building.city}, #{building.state}, #{building.zipcode}"
#     else
#       json.search_term "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
#     end
#     json.term_address "#{building.building_street_address}"
#     json.category 'Building'
#   end
# end

# if @buildings_by_address.present?
#   json.array! @buildings_by_address do |building|
#     json.id building.id
#     json.search_term "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
#     json.term_address "#{building.building_street_address}"
#     json.category 'Building'
#   end
# end

# if @buildings_by_zipcode.present?
#   json.array! @buildings_by_zipcode do |building|
#     json.id building.id
#     #if building.id == @buildings_by_zipcode.first.id
#     json.search_term "#{building.zipcode} - #{building.city}, #{building.state}"
#     json.term_zipcode "#{building.zipcode}-#{building.formatted_city}"
#     json.category 'Zipcode'
#   end
# end

# if @buildings_by_city.present?
#   json.array! @buildings_by_city do |building|
#     json.id building.id
#     #condition because if city name and neighborhood name is same then search will have duplicates items
#     if building.city.present? and !arr.include? building.city
#       json.search_term "#{building.city}, #{building.state}"
#       json.term_city "#{building.formatted_city}-#{building.state.downcase}"
#       json.category 'City'
#     end 
#   end
# end

# # if @search_by_mangement.present?
# #   json.array! @search_by_mangement do |company|
# #     json.id company.id
# #     json.search_term "#{company.name}" #if !arr.include? company.name
# #     json.management_company_name "#{company.name}"
# #   end
# # end

# case @result_type
# when 'no_match_found'
#   json.no_match_found 'No matches found - Add Your Building'
# end
