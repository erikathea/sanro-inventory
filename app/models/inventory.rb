class Inventory < ActiveRecord::Base
  belongs_to :item
  belongs_to :inventory
  belongs_to :incoming_receipt_detail
  belongs_to :outgoing_receipt_detail
  validates :unit_price, presence: :true, if: "incoming_receipt_detail.present?"
  validates :current_stock, presence: :true
  before_create :set_initial_stock_count

  def unit_price_amount
    unit_price * current_stock
  end

  private
  def set_initial_stock_count
    self.initial_stock = self.current_stock if !self.outgoing_receipt_detail
  end
end
