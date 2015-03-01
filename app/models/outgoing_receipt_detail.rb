class OutgoingReceiptDetail < ActiveRecord::Base
  belongs_to :outgoing_receipt
  belongs_to :inventory
end
