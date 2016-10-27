case @result_type
  when 'buildings'
    json.array! @buildings do |building|
      json.id building.id
      json.search_term "#{building.building_name} - #{building.building_street_address}, #{building.city}, #{building.state}, #{building.zipcode}"
      json.term "#{building.building_name}"
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
    end
end