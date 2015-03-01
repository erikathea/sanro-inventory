class CreateIncomingReceipts < ActiveRecord::Migration
  def change
    create_table :incoming_receipts do |t|
      t.string :receipt_number, limit: 20
      t.string :supplier, limit: 50
      t.string :address, limit: 50
      t.datetime :date_issued
      t.decimal :total, precision: 15, scale:2
      t.decimal :amount_received, precision: 15, scale:2
      t.decimal :balance, precision: 15, scale:2

      t.timestamps
    end
  end
end
