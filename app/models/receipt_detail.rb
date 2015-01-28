class ReceiptDetail < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :item
  accepts_nested_attributes_for :item, :reject_if => :all_blank, :allow_destroy => true
end
