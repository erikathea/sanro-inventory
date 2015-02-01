class ReceiptDetail < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :item
  accepts_nested_attributes_for :item, :reject_if => :all_blank, :allow_destroy => true

  def create_or_update_inventory_item(receipt_type)
    item = Item.find_by(description: self.description.downcase, part_number: self.part_number.downcase)
    if !item.present?
      item = Item.new(description: self.description, part_number: self.part_number)
    end
    item.update_stock(stock(receipt_type, self.qty), self.unit_price)
    item.save
    self.update_attributes(item: item)
  end

  private
  def stock(receipt_type, qty)
    case receipt_type
    when Receipt::TYPES[:acquisition]
      qty
    else
      - (qty)
    end
  end
end
