json.array!(@incoming_receipt_details) do |incoming_receipt_detail|
  json.extract! incoming_receipt_detail, :id, :incoming_receipt_id, :description, :part_number, :total, :unit_price, :qty, :unit
  json.url incoming_receipt_detail_url(incoming_receipt_detail, format: :json)
end
