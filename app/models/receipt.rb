class Receipt < ActiveRecord::Base
  has_many :receipt_details
  accepts_nested_attributes_for :receipt_details, :reject_if => :all_blank, :allow_destroy => true
end
