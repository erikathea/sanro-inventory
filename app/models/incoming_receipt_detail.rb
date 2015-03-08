class IncomingReceiptDetail < ActiveRecord::Base
  belongs_to :incoming_receipt

  validates :description, presence: :true
  validates :part_number, presence: :true
  validates :qty, presence: :true
  validates :unit, presence: :true
  validates :unit_price, presence: :true
  validates :total, presence: :true

  before_save :strip_and_upcase_strings

  private
  def strip_and_upcase_strings
    self.description = self.description.strip.upcase
    self.part_number = self.part_number.strip.upcase
  end
end
