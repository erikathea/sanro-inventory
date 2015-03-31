class AddPurchaseOrderNoToOutgoingReceipt < ActiveRecord::Migration
  def change
    add_column :outgoing_receipts, :po_no, :string
  end
end
