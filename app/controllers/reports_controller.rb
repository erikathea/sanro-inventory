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
    details = OutgoingReceiptDetail.joins(:outgoing_receipt).where(outgoing_receipts: {date_issued: report_period, sale_type: 1})
    @inventories = Inventory.where(outgoing_receipt_detail: details).where.not(current_stock: 0).includes(:outgoing_receipt_detail).includes(:item)
  end

  def sis
    @title = 'Sale Invoices'
    details = OutgoingReceiptDetail.joins(:outgoing_receipt).where(outgoing_receipts: {date_issued: report_period, sale_type: 0})
    @inventories = Inventory.where(outgoing_receipt_detail: details).where.not(current_stock: 0).includes(:outgoing_receipt_detail).includes(:item)
  end

  def bill
  end

  private
  def report_period
    if params[:period][:type] == 'monthly'
      month = params[:period][:month].to_i
      year = params[:period][:year].to_i
      @date_header = Date.new(year, month).strftime('%B %Y')
      return (Date.new(year, month))...(Date.new(year, month).next_month)
    elsif params[:period][:type] == 'quarter'
      year = params[:period][:year].to_i
      @date_header = "#{params[:period][:quarter]} Quarter #{year}"
      end_month = params[:period][:quarter].to_i * 3
      start_month = end_month - 2
      return (Date.new(year, start_month))...(Date.new(year, end_month))
    else
      year = params[:period][:year].to_i
      @date_header = Date.new(year).strftime('%Y')
      return (Date.new(year))...(Date.new(year).next_year)
    end
  end
end