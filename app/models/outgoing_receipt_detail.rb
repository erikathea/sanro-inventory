class OutgoingReceiptDetail < ReceiptDetail
  validates :selling_price, presence: :true
  def compute_total_selling_price
    self.total = self.qty * self.selling_price
  end
end