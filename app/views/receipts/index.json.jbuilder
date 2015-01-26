json.array!(@receipts) do |receipt|
  json.extract! receipt, :id
  json.url receipt_url(receipt, format: :json)
end
