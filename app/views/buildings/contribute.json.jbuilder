json.array!(@buildings) do |building|
  json.(building, :id,:building_name, :building_street_address, :city, :state, :zipcode)
 
  json.units building.units do |unit|
    json.(unit, :id, :name, :square_feet, :number_of_bedrooms, :number_of_bathrooms)
  end
end
