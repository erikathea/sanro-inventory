class IncomingReceiptDetail < ReceiptDetail
  validates :unit_price, presence: :true

  def compute_total_unit_price
    self.total = self.qty * self.unit_price
  end
end
