class Receipt < ActiveRecord::Base
  has_many :receipt_details, dependent: :destroy
  accepts_nested_attributes_for :receipt_details, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :receipt_details
  validate :has_one_receipt_detail
  validates :date_issued, presence: :true
  validates :receipt_number, presence: :true

  before_save :add_receipt_details_item_id

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
  def has_one_receipt_detail
    if self.receipt_details.empty?
      errors.add(:receipt_details, ': Please add at least one item')
    end
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
