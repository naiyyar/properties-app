json.array!(@review_flags) do |review_flag|
  json.extract! review_flag, :id
  json.url review_flag_url(review_flag, format: :json)
end
