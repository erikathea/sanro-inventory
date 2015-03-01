class CreateOutgoingReceiptDetails < ActiveRecord::Migration
  def change
    create_table :outgoing_receipt_details do |t|
      t.belongs_to :outgoing_receipt, index: true
      t.belongs_to :inventory, index: true
      t.decimal :total, precision: 15, scale:2
      t.float :qty
      t.string :unit, limit: 5

      t.timestamps
    end
  end
end
