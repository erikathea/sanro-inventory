json.array!(@outgoing_receipts) do |outgoing_receipt|
  json.extract! outgoing_receipt, :id, :receipt_number, :client, :address, :date_issued, :total, :amount_received, :balance, :type
  json.url outgoing_receipt_url(outgoing_receipt, format: :json)
end
