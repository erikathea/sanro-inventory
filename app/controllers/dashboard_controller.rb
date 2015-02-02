class DashboardController < ApplicationController
  def index
    @delivery = Receipt.where(receipt_type: Receipt::TYPES[:acquisition])
    @dr = Receipt.where(receipt_type: Receipt::TYPES[:delivery_receipt])
    @si = Receipt.where(receipt_type: Receipt::TYPES[:sales_invoice])
    @inventories = Inventory.all
  end
end
