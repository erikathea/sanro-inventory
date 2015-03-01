class DropReceiptAndReceiptDetailsTables < ActiveRecord::Migration
  def change
    drop_table :receipts
    drop_table :receipt_details
  end
end
