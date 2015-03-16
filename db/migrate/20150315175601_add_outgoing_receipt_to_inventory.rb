class AddOutgoingReceiptToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :outgoing_receipt_id, :integer
    add_index :inventories, :outgoing_receipt_id
  end
end
