case @result_type
when 'building_name'
  json.array! @buildings do |building|
    json.id building.id
    json.search_term "#{building.building_name} - #{building.building_street_address}, #{building.city}, #{building.state}, #{building.zipcode}"
    json.term "#{building.building_street_address}"
  end
when 'cities'
  json.array! @buildings do |building|
    json.id building.id
    json.search_term "#{building.city}, #{building.state}"
  end
when 'address'
  json.array! @buildings do |building|
    json.id building.id
    json.search_term "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
    json.term "#{building.building_street_address}"
  end
when 'zipcode'
  json.array! @buildings do |building|
    json.id building.id
    if building.id == @buildings.first.id
      json.search_term "#{building.zipcode} - #{building.city}, #{building.state}"
    else
      json.search_term "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
      json.term "#{building.building_street_address}"
    end
  end
when 'neighborhood'
  json.array! @buildings do |building|
    json.id building.id
    json.search_term "#{building.neighborhood}, #{building.city}, #{building.state}"
    json.neighborhoods "#{building.neighborhood}"
  end
  json.array! @buildings do |building|
    json.id building.id
    if building.building_name.present?
      json.search_term "#{building.building_name} - #{building.building_street_address}, #{building.city}, #{building.state}, #{building.zipcode}"
    else
      json.search_term "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
    end
    json.term "#{building.building_street_address}"
  end

when 'pneighborhood'
  arr = []
  json.array! @buildings do |building|
    json.id building.id
    if building.neighborhoods_parent.present?
      json.search_term "#{building.neighborhoods_parent}, #{building.city}, #{building.state}"
      json.neighborhoods "#{building.neighborhoods_parent}"
      arr << building.neighborhoods_parent
    end
  end

  json.array! @buildings do |building|
    json.id building.id
    if building.neighborhood.present? and !arr.include? building.neighborhood
      json.search_term "#{building.neighborhood}, #{building.city}, #{building.state}"
      json.neighborhoods "#{building.neighborhood}"
    end
  end

  json.array! @buildings do |building|
    json.id building.id
    if building.building_name.present?
      json.search_term "#{building.building_name} - #{building.building_street_address}, #{building.city}, #{building.state}, #{building.zipcode}"
    else
      json.search_term "#{building.building_street_address}, #{building.city}, #{building.state} #{building.zipcode}"
    end
    json.term "#{building.building_street_address}"
  end
  
when 'no_match_found'
    json.no_match_found 'No matches found - Add a new building'
end
