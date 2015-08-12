class Item < ActiveRecord::Base
  has_many :inventories, dependent: :destroy
  accepts_nested_attributes_for :inventories, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :inventories
  validates :description, presence: :true
  validates :part_number, presence: :true
  validate :item_already_exists?

  def total_stock
    self.inventories.where('incoming_receipt_detail_id IS NOT NULL OR initial_stock IS NOT NULL').map(&:current_stock).inject{|sum, x| sum + x}
  end

  def full_description
    "#{description} - #{part_number}" if self.description.present? && self.part_number.present?
  end

  def unit_price
    self.inventories.where('current_stock > 0').first
  end

  def self.merge_preview(items)
    total_stock = 0
    inventories = []
    remarks = ""
    items.each do |item|
      total_stock += item.total_stock.to_f
      remarks = "#{remarks};Merged #{item.description} - #{item.part_number} (#{item.id})"
      inventories << item.inventories
    end
    {item: items.first, inventories: inventories.flatten, total_stock: total_stock, remarks: remarks}
  end

  def merge(items)
  end

  def unmerge
  end

  private
  def item_already_exists?
    item = Item.find_by_description_and_part_number(self.description, self.part_number)
    if (item && item.id != self.id)
      errors.add(:description, 'already exists')
      errors.add(:part_number, 'already exists')
    end
  end
end
