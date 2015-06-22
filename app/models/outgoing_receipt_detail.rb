class OutgoingReceiptDetail < ActiveRecord::Base
  belongs_to :outgoing_receipt
  belongs_to :item
  has_one :inventory

  validates :selling_price, presence: true
  validates :unit_price, presence: true
  validates :qty, presence: true
  validate :has_item?
  validate :has_stock?, on: :create
  validate :has_enough_stock?, on: :update

  after_create :create_inventory
  after_update :update_inventory

  def sp_amount
    qty * selling_price
  end

  private
  def has_item?
    errors.add(:item, 'not found') if !self.item.present?
  end

  def has_stock?
    errors.add(:item, 'has insufficient stock') if self.qty > self.item.total_stock
  end

  def has_enough_stock?
    # scenario: purchasing additional qty of the item
    diff_qty = self.qty_was - self.qty
    if diff_qty < 0
     errors.add(:item, 'has insufficient stock') if diff_qty.abs > self.item.total_stock
    end
  end

  def create_inventory
    Inventory.create(
      outgoing_receipt_detail: self,
      unit_price: self.unit_price,
      current_stock: - self.qty,
      item: self.item
      )
  end

  def update_inventory
    self.inventory.update(unit_price: unit_price, current_stock: -qty)
  end
end
