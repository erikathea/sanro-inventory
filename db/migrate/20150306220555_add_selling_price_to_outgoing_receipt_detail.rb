class AddSellingPriceToOutgoingReceiptDetail < ActiveRecord::Migration
  def change
    add_column :outgoing_receipt_details, :selling_price, :decimal, precision: 15, scale:2
  end
end
