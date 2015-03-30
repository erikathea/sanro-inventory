class ReportsController < ApplicationController
  def stocks
    @title = 'List of Stocks'
    @inventories = Inventory.includes(:item).order('items.description').where('current_stock > 0')
  end

  def deliveries
    @title = 'Delivery Inventory'
    receipts = IncomingReceipt.order(:date_issued).where(date_issued: report_period).includes(:incoming_receipt_details)
    @details = receipts.map(&:incoming_receipt_details).flatten
  end

  def drs
    @title = 'Delivery Receipts'
  end

  def sis
    @title = 'Sale Invoices'
  end

  private
  def report_period
    if params[:period][:type] == 'monthly'
      month = params[:period][:month].to_i
      year = params[:period][:year].to_i
      @date_header = Date.new(year, month).strftime('%B %Y')
      return (Date.new(year, month))...(Date.new(year, month).next_month)
    else
      year = params[:period][:year].to_i
      @date_header = Date.new(year).strftime('%Y')
      return (Date.new(year))...(Date.new(year).next_year)
    end
  end
end