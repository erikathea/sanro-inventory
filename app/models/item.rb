class Item < ActiveRecord::Base
  has_many :inventories, dependent: :destroy
  accepts_nested_attributes_for :inventories, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :inventories
  validates :description, presence: :true
  validates :part_number, presence: :true

  def total_stock
    self.inventories.sum(:current_stock)
  end
end
