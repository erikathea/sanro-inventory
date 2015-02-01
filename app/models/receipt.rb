class Receipt < ActiveRecord::Base
  has_many :receipt_details
  accepts_nested_attributes_for :receipt_details, :reject_if => :all_blank, :allow_destroy => true
  TYPES = {
    :acquisition => 0,
    :delivery_receipt => 1,
    :sales_invoice => 2
  }

  def update_inventory
    self.receipt_details.each do |receipt_detail|
      receipt_detail.create_or_update_inventory_item(self.receipt_type)
    end
  end

  def receipt_type
    case read_attribute(:receipt_type)
    when Receipt::TYPES[:acquisition]
      return "Delivery"
    when Receipt::TYPES[:delivery_receipt]
      return "DR"
    when Receipt::TYPES[:sales_invoice]
      return "SI"
    end
  end
end
