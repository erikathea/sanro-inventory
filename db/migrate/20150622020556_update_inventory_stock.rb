class UpdateInventoryStock < ActiveRecord::Migration
  def change
    Inventory.all.each do |i|
      i.update(current_stock: i.initial_stock)
      if i.outgoing_receipt_detail
        i.outgoing_receipt_detail.update(unit_price: i.unit_price)
      end
    end
  end
end
