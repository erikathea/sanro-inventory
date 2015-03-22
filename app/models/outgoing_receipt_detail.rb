class OutgoingReceiptDetail < ActiveRecord::Base
  belongs_to :outgoing_receipt
  belongs_to :item

  validates :selling_price, presence: true
  validates :qty, presence: true
  validate :has_item?

  after_create :update_inventory_upon_create
  after_update :update_inventory_upon_update

  private
  def has_item?
    errors.add(:item, 'not found') if !self.item.present?
  end

  def update_inventory_upon_create
    inventory = Inventory.new(
      item: item,
      current_stock: -(self.qty),
      outgoing_receipt: self.outgoing_receipt
    )
    inventory.save
  end

  def update_inventory_upon_update
    inventory = self.item.inventories.where(outgoing_receipt: self.outgoing_receipt).first
    inventory.update_attributes(current_stock: -(self.qty))
  end
end
