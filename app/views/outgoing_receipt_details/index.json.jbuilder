json.array!(@outgoing_receipt_details) do |outgoing_receipt_detail|
  json.extract! outgoing_receipt_detail, :id, :outgoing_receipt_id, :total, :qty, :unit, :inventory_id
  json.url outgoing_receipt_detail_url(outgoing_receipt_detail, format: :json)
end
