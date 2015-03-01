class IncomingReceiptDetail < ActiveRecord::Base
  belongs_to :incoming_receipt

  private
  def strip_and_upcase_strings
    self.description = self.description.strip.upcase
    self.part_number = self.part_number.strip.upcase
  end
end
