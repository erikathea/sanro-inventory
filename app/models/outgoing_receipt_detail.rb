class OutgoingReceiptDetail < ActiveRecord::Base
  belongs_to :outgoing_receipt
  belongs_to :item

  validates :selling_price, presence: true
  validates :qty, presence: true
  validate :has_item?

  after_save :update_inventory

  private
  def has_item?
    errors.add(:item, 'not found') if !self.item.present?
  end

  def update_inventory
    inventory = Inventory.new(
      item: item,
      current_stock: -(self.qty),
      outgoing_receipt: self.outgoing_receipt
    )
    inventory.save
  end
end
