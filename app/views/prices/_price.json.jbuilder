json.extract! price, :id, :priceable_id, :priceable_type, :min_price, :max_price, :bed_type, :created_at, :updated_at
json.url price_url(price, format: :json)
