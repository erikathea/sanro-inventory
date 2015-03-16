class ChangeInventoryToItemInOutgoingReceiptDetail < ActiveRecord::Migration
  def change
    rename_column :outgoing_receipt_details, :inventory_id, :item_id
  end
end
