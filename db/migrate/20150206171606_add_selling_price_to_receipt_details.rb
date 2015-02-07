class AddSellingPriceToReceiptDetails < ActiveRecord::Migration
  def change
    add_column :receipt_details, :selling_price, :decimal, precision: 15, scale: 2
  end
end
