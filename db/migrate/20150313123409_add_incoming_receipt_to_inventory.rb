class AddIncomingReceiptToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :incoming_receipt_id, :integer
    add_index :inventories, :incoming_receipt_id
  end
end
