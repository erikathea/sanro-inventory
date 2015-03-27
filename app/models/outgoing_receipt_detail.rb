class OutgoingReceiptDetail < ActiveRecord::Base
  belongs_to :outgoing_receipt
  belongs_to :item

  validates :selling_price, presence: true
  validates :qty, presence: true
  validate :has_item?
  validate :has_stock?, on: :create
  validate :has_enough_stock?, on: :update

  after_create :update_inventory_upon_create
  before_update :update_inventory_upon_update

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

  def update_inventory_upon_create
    update_inventory_item(self.qty)
  end

  def update_inventory_item(new_qty)
    inventories = Inventory.order(:id).where("item_id = #{item.id} AND current_stock > 0")
    inventory = inventories.first
    if new_qty < inventory.current_stock
      create_inventory(-(new_qty), inventory.unit_price, inventory)
      stock = inventory.current_stock - new_qty
      inventory.update_attributes(current_stock: stock)
    else
      break_to_multiple_inventories(inventories)
    end
  end

  def create_inventory(stock, unit_price, inventory=nil, initial_stock=nil)
    inventory = Inventory.new(
        item: item,
        current_stock: stock,
        outgoing_receipt: self.outgoing_receipt,
        unit_price: unit_price,
        initial_stock: initial_stock,
        inventory: inventory
      )
    inventory.save
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
      create_inventory(-stock, current_inventory.unit_price, current_inventory)
      current_inventory.update_attributes(current_stock: current_inventory_stock)
    end
  end

  def update_inventory_upon_update
    inventories = Inventory.order(:id).where("item_id = #{item.id} AND inventory_id IS NOT NULL").reverse
    qty_diff = self.qty_was - self.qty

    if qty_diff < 0
      # qty_diff negative, scenario: purchasing additional qty of item
      inventory = inventories.first.inventory
      if inventory.current_stock > 0
        stock = inventory.current_stock + qty_diff
        inventory.update_attributes(current_stock: stock)

        stock = inventory.first.current_stock + qty_diff
        inventory.first.update_attributes(current_stock: stock)
      else
        update_inventory_item(qty_diff.abs)
      end
    else
      # qty positive, scenario: returning of qty item
    end
  end
end
