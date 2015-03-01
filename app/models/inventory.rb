class Inventory < ActiveRecord::Base
  belongs_to :item
  validates :unit_price, presence: :true
  validates :current_stock, presence: :true
end
