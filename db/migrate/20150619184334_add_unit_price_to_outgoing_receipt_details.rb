class AddUnitPriceToOutgoingReceiptDetails < ActiveRecord::Migration
  def change
    add_column :outgoing_receipt_details, :unit_price, :decimal
  end
end
