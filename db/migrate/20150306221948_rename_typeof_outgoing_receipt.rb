class RenameTypeofOutgoingReceipt < ActiveRecord::Migration
  def change
    rename_column :outgoing_receipts, :type, :sale_type
  end
end
