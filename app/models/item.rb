class Item < ActiveRecord::Base
  validate :check_description_part_number_combination
  before_save :set_to_up_case

  def check_description_part_number_combination
    item = Item.find_by(description: self.description.upcase, part_number: self.part_number.upcase)
    if item.present?
      errors.add(:description, 'Item already exists.')
      errors.add(:part_number, 'Item already exists.')
    end
  end

  private
    def set_to_up_case
      self.description = self.description.upcase
      self.part_number = self.part_number.upcase
    end
end
