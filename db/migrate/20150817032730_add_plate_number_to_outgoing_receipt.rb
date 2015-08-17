class AddPlateNumberToOutgoingReceipt < ActiveRecord::Migration
  def change
    add_column :outgoing_receipts, :plate_no, :string
  end
end
