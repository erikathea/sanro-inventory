json.array!(@inventories) do |inventory|
  json.extract! inventory, :id, :item_id, :unit_price, :current_stock
  json.url inventory_url(inventory, format: :json)
end
