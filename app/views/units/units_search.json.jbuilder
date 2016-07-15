json.array!(@units) do |unit|
  json.(unit, :id, :name, :square_feet, :number_of_bedrooms, :number_of_bathrooms)
end
