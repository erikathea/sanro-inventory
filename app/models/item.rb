class Item < ActiveRecord::Base
  has_many :inventories, dependent: :destroy
  accepts_nested_attributes_for :inventories, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :inventories
  validates :description, presence: :true
  validates :part_number, presence: :true
  validate :item_already_exists?

  def total_stock
    self.inventories.map(&:current_stock).inject{|sum, x| sum + x}
  end

  def full_description
    "#{description} - #{part_number}" if self.description.present? && self.part_number.present?
  end

  private
  def item_already_exists?
    if(Item.find_by_description_and_part_number(self.description, self.part_number))
      errors.add(:description, 'already exists')
      errors.add(:part_number, 'already exists')
    end
  end
end
