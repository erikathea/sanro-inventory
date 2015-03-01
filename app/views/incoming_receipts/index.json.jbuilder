json.array!(@incoming_receipts) do |incoming_receipt|
  json.extract! incoming_receipt, :id, :receipt_number, :supplier, :address, :date_issued, :total, :amount_received, :balance
  json.url incoming_receipt_url(incoming_receipt, format: :json)
end
