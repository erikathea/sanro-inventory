class OutgoingReceiptDetail < ActiveRecord::Base
  belongs_to :outgoing_receipt
  belongs_to :inventory
  validates :selling_price, presence: true
  validates :qty, presence: true
  validate :inventory_exists?
  private
  def inventory_exists?
    if !self.inventory.present?
      errors(:inventory, 'Wrong inventory number')
    end
  end
end
