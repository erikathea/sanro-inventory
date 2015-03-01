class Receipt < ActiveRecord::Base
  self.inheritance_column = :receipt_type

  validate :has_one_receipt_detail?
  validate :has_filled_receipt_details?
  validates :date_issued, presence: :true
  validates :receipt_number, presence: :true

  before_save :add_receipt_details_item_id, if: :is_outgoing?

  TYPES = {
    :acquisition => 0,
    :delivery_receipt => 1,
    :sales_invoice => 2
  }

  def update_inventory
    self.receipt_details.each do |receipt_detail|
      receipt_detail.create_or_update_inventory_item(self.read_attribute(:receipt_type))
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

  private
  def has_one_receipt_detail?
    if self.receipt_details.empty?
      errors.add(:receipt_details, ': Please add at least one item')
    end
  end

  def has_filled_receipt_details?
    self.receipt_details.each do |detail|
      if(is_incoming?)
        is_price_present = detail.unit_price.present?
      else
        is_price_present = detail.selling_price.present?
      end

      if(detail.description.empty? ||
        detail.part_number.empty? ||
        !is_price_present ||
        !detail.qty.present?)
        errors.add(:receipt_details, ': Please complete the receipt details')
      end
    end
  end

  def is_incoming?
    read_attribute(:receipt_type) == Receipt::TYPES[:acquisition]
  end

  def is_outgoing?
    read_attribute(:receipt_type) != Receipt::TYPES[:acquisition]
  end

  def add_receipt_details_item_id
    self.receipt_details.each do |detail|
      item = Item.find_by(description: detail.description.upcase, part_number: detail.part_number.upcase)
      if read_attribute(:receipt_type) == Receipt::TYPES[:acquisition] && !item.present?
        item = Item.new(description: detail.description.upcase, part_number: detail.part_number.upcase)
      end
      detail.item = item
    end
  end
end
