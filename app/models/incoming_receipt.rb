class IncomingReceipt < ActiveRecord::Base
  has_many :incoming_receipt_details, dependent: :destroy
  accepts_nested_attributes_for :incoming_receipt_details, :reject_if => :all_blank, :allow_destroy => true

  validate :has_one_receipt_detail?
  validate :check_supplier_receipt_number?
  validates :date_issued, presence: :true
  validates :receipt_number, presence: :true
  validates :supplier, presence: :true
  validates :total, presence: :true

  before_save :strip_and_upcase_strings

  private
  def has_one_receipt_detail?
    errors.add(:incoming_receipt_details, ': Please add at least one receipt item') if self.incoming_receipt_details.empty?
  end

  def check_supplier_receipt_number?
    receipt = IncomingReceipt.find_by_receipt_number_and_supplier(self.receipt_number, self.supplier)
    if (receipt && receipt.id != self.id)
      errors.add(:receipt_number, 'already exists')
    end
  end

  def strip_and_upcase_strings
    self.receipt_number = self.receipt_number.strip.upcase
    self.supplier = self.supplier.strip.upcase
    self.address = self.address.strip.upcase
  end
end
