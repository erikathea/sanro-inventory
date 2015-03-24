class OutgoingReceiptDetail < ActiveRecord::Base
  belongs_to :outgoing_receipt
  belongs_to :item

  validates :selling_price, presence: true
  validates :qty, presence: true
  validate :has_item?

  after_create :update_inventory_upon_create
  before_update :update_inventory_upon_update

  private
  def has_item?
    errors.add(:item, 'not found') if !self.item.present?
  end

  def update_inventory_upon_create
    update_inventory_item(self.qty)
  end

  def break_to_multiple_inventories(inventories)
    temp_qty = self.qty

    inventories.each do |current_inventory|
      break if temp_qty <= 0

      stock = temp_qty
      current_inventory_stock = current_inventory.current_stock - temp_qty

      if (temp_qty > current_inventory.current_stock)
        stock = current_inventory.current_stock
        current_inventory_stock = 0
      end
      temp_qty = temp_qty - current_inventory.current_stock
      create_inventory(-stock, current_inventory.unit_price)
      current_inventory.update_attributes(current_stock: current_inventory_stock)
    end
  end

  def create_inventory(stock, unit_price, initial_stock=nil)
    inventory = Inventory.new(
        item: item,
        current_stock: stock,
        outgoing_receipt: self.outgoing_receipt,
        unit_price: unit_price,
        initial_stock: initial_stock
      )
    inventory.save
  end

  def update_inventory_item(new_qty)
    inventories = Inventory.order(:id).where("item_id = #{item.id} AND current_stock > 0")
    inventory = inventories.first
    if new_qty < inventory.current_stock
      create_inventory(-(new_qty), inventory.unit_price)
      stock = inventory.current_stock - new_qty
      inventory.update_attributes(current_stock: stock)
    else
      break_to_multiple_inventories(inventories)
    end
  end

  def update_inventory_upon_update
    qty_diff = self.qty_was - self.qty
    # qty_diff results:
    # negative, create inventory with negative stock count
    # positive, create inventory with positive stock count

    update_inventory_item(qty_diff.abs) if qty_diff < 0

    if qty_diff > 0
      inventory = Inventory.order(:id).where("outgoing_receipt_id = #{outgoing_receipt.id}").last
      stock = inventory.current_stock + qty_diff
      inventory.update_attributes(current_stock: stock)
      create_inventory(qty_diff, inventory.unit_price, 0.0)
    end
  end
end
