class CreateReceiptDetails < ActiveRecord::Migration
  def change
    create_table :receipt_details do |t|
      t.belongs_to :receipt, index:true
      t.belongs_to :item, index:true
      t.float :qty
      t.string :unit, limit: 5, null: true
      t.decimal :unit_price, precision: 15, scale:2
      t.decimal :total, precision: 15, scale:2
      t.timestamps null: false
    end
  end
end
