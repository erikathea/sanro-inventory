class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.string :receipt_number, index:true
      t.string :company_name, limit: 20
      t.string :address, limit: 50, null: true
      t.integer :type
      t.decimal :total, precision: 15, scale:2
      t.decimal :amount_received, precision: 15, scale:2
      t.decimal :balance, precision: 15, scale:2
      t.date :date_issued
      t.timestamps null: false
    end
  end
end
