class CreateIncomingReceiptDetails < ActiveRecord::Migration
  def change
    create_table :incoming_receipt_details do |t|
      t.belongs_to :incoming_receipt, index: true
      t.string :description
      t.string :part_number
      t.decimal :total, precision: 15, scale:2
      t.decimal :unit_price, precision: 15, scale:2
      t.float :qty
      t.string :unit, limit:5

      t.timestamps
    end
  end
end
