class IncomingReceiptDetail < ActiveRecord::Base
  belongs_to :incoming_receipt

  validates :description, presence: :true
  validates :part_number, presence: :true
  validates :qty, presence: :true
  validates :unit, presence: :true
  validates :unit_price, presence: :true
  validates :total, presence: :true

  before_save :strip_and_upcase_strings
  after_create :update_inventory_upon_create
  after_update :update_inventory_upon_update

  private
  def strip_and_upcase_strings
    self.description = self.description.strip.upcase
    self.part_number = self.part_number.strip.upcase
  end

  def update_inventory_upon_create
    item = get_item
    inventory = Inventory.new(
      item: item,
      current_stock: self.qty,
      initial_stock: self.qty,
      unit_price: self.unit_price,
      incoming_receipt_detail: self
    )
    inventory.save
  end

  def update_inventory_upon_update
    begin
      item = Item.find_by_description_and_part_number(self.description, self.part_number)
      inventory = item.inventories.where(incoming_receipt_detail: self).first  
      stock_diff = self.qty - inventory.initial_stock
      current_stock = inventory.current_stock + stock_diff
      inventory.update_attributes(initial_stock: self.qty, current_stock: current_stock, unit_price: self.unit_price)
    rescue 
      self.id
    end
    
    
  end

  def get_item
    item = Item.find_by_description_and_part_number(self.description, self.part_number)
    if !item
      item = Item.new(description: self.description, part_number: self.part_number)
      item.save
    end
    return item
  end
end
