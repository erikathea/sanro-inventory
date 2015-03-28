class ChangeReceiptToReceiptDetailInInventory < ActiveRecord::Migration
  def change
    rename_column :inventories, :outgoing_receipt_id, :outgoing_receipt_detail_id
    rename_column :inventories, :incoming_receipt_id, :incoming_receipt_detail_id
  end
end
