case @result_type
  when 'buildings'
    json.array! @buildings do |building|
      json.id building.id
      json.search_term "#{building.building_name}, #{building.city}, #{building.state}"
      json.term "#{building.building_name}"
    end
  when 'cities'
    json.array! @buildings do |building|
      json.id building.id
      json.search_term "#{building.city}, #{building.state}"
      json.term "#{building.city}"
    end
  when 'address'
    json.array! @buildings do |building|
      json.id building.id
      json.search_term "#{building.building_street_address}, #{building.state}, #{building.state}"
      json.term "#{building.building_street_address}"
    end
  when 'zipcode'
    json.array! @buildings do |building|
      json.id building.id
      json.search_term "#{building.city}, #{building.state}, #{building.zipcode}"
      json.term "#{building.zipcode}"
    end
end