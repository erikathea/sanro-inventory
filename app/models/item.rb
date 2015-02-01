class Item < ActiveRecord::Base
  validate :check_description_part_number_combination
  before_save :set_to_lower_case
  has_one :inventory

  def update_stock(stock, price)
    inventory = self.inventory
    if !inventory.present? || inventory.unit_price!=price
      inventory = Inventory.new(item: self, unit_price:price, current_stock: stock)
    else
      inventory.current_stock = inventory.current_stock + stock
    end
    inventory.save
  end

  def check_description_part_number_combination
    item = Item.find_by(description: self.description.downcase, part_number: self.part_number.downcase)
    if item.present?
      errors.add(:description, 'Item already exists.')
      errors.add(:part_number, 'Item already exists.')
    end
  end

  private
    def set_to_lower_case
      self.description = self.description.downcase
      self.part_number = self.part_number.downcase
    end
end
