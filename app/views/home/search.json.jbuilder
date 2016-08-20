json.array!(@buildings) do |building|
  json.(building, :id,:state, :city)
end
