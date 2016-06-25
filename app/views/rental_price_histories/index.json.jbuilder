json.array!(@rental_price_histories) do |rental_price_history|
  json.extract! rental_price_history, :id
  json.url rental_price_history_url(rental_price_history, format: :json)
end
