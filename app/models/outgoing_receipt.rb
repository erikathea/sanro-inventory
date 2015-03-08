class OutgoingReceipt < ActiveRecord::Base
  has_many :outgoing_receipt_details, dependent: :destroy
  accepts_nested_attributes_for :outgoing_receipt_details, :reject_if => :all_blank, :allow_destroy => true

  validate :has_one_receipt_detail?
  validates :date_issued, presence: :true
  validates :receipt_number, presence: :true
  validates :receipt_number, uniqueness: :true
  validates :total, presence: :true
  validates :sale_type, presence: :true

  before_save :strip_and_upcase_strings

  def type_title
    self.sale_type == 0? 'Sales Invoice (SI)' : 'Delivery Receipt (DR)'
  end

  private
  def has_one_receipt_detail?
    if self.outgoing_receipt_details.empty?
      errors.add(:outgoing_receipt_details, ': Please add at least one receipt item')
    end
  end

  def strip_and_upcase_strings
    self.receipt_number = self.receipt_number.strip.upcase
    self.client = self.client.strip.upcase
    self.address = self.address.strip.upcase
  end
end
