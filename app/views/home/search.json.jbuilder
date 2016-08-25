case @result_type
  when 'buildings'
    json.array! @buildings do |building|
      json.id building.id
      json.search_term "#{building.building_name}, #{building.city}, #{building.state}"
    end
  when 'cities'
    json.array! @buildings do |building|
      json.id building.id
      json.search_term "#{building.city}, #{building.state}"
    end
  when 'zipcode'
    json.array! @buildings do |building|
      json.id building.id
      json.search_term "#{building.city}, #{building.state}, #{building.zipcode}"
    end
end