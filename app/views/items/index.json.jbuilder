json.array!(@items) do |item|
  json.extract! item, :id, :description, :part_number, :selling_price
  json.url item_url(item, format: :json)
end
