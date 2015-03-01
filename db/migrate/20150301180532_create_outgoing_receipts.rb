class CreateOutgoingReceipts < ActiveRecord::Migration
  def change
    create_table :outgoing_receipts do |t|
      t.string :receipt_number, limit: 20
      t.string :client, limit: 50
      t.string :address, limit: 50
      t.datetime :date_issued
      t.decimal :total, precision: 15, scale:2
      t.decimal :amount_received, precision: 15, scale:2
      t.decimal :balance, precision: 15, scale:2
      t.integer :type

      t.timestamps
    end
  end
end
