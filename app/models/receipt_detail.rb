class ReceiptDetail < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :item
  before_save :strip_and_upcase_strings
  accepts_nested_attributes_for :item, :reject_if => :all_blank, :allow_destroy => true
  validates :qty, presence: :true

  def create_or_update_inventory_item(receipt_type)
    if receipt_type == Receipt::TYPES[:acquisition]
      incoming_inventory
    else # outgoing: DR & SI
      outgoing_inventory
    end
  end

  private
  def incoming_inventory
    item = Item.find_by(description: self.description.upcase, part_number: self.part_number.upcase)
    if !item.present?
      item = create_item
      add_inventory(item)
    else
      check_item_inventory(item)
    end
  end

  def outgoing_inventory
    item = Item.find_by(description: self.description.upcase, part_number: self.part_number.upcase)
    if item.present?
      inventory = Inventory.limit(1).where('current_stock > 0 and item_id = ?', item.id).first
      update_inventory(inventory, - (self.qty))
      self.update_attribute(:unit_price, inventory.unit_price)
    end
  end

  def create_item
    item = Item.new(description: self.description, part_number: self.part_number)
    item.save
    return item
  end

  def add_inventory(item)
    inventory = Inventory.new(item: item, unit_price:self.unit_price, current_stock: self.qty)
    inventory.save
  end

  def check_item_inventory(item)
    inventory = Inventory.limit(1).where('current_stock > 0 and item_id = ?', item.id).first
    if inventory.unit_price != self.unit_price
      add_inventory(item)
    else
      update_inventory(inventory, self.qty)
    end
  end

  def update_inventory(inventory, qty)
    new_stock_count = inventory.current_stock + qty
    inventory.update_attribute(:current_stock, new_stock_count)
  end

  def strip_and_upcase_strings
    self.description = self.description.strip.upcase
    self.part_number = self.part_number.strip.upcase
  end
end
