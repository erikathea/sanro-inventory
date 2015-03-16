class Inventory < ActiveRecord::Base
  belongs_to :item
  belongs_to :incoming_receipt
  belongs_to :outgoing_receipt
  validates :unit_price, presence: :true
  validates :current_stock, presence: :true
end
