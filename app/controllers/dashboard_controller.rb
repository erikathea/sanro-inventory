class DashboardController < ApplicationController
  def index
    @inventories = Inventory.all
  end

  def generate_report
    if params[:report] == 'Stocks'
      redirect_to stock_report_path()
    else
      @period = set_report_period if params[:report]
      if params[:report] == 'Delivery Inventory'
        redirect_to delivery_report_path(period: @period)
      elsif params[:report] == 'Delivery (DR)'
        redirect_to dr_report_path(period: @period)
      elsif params[:report] == 'Sale Invoice (SI)'
        redirect_to si_report_path(period: @period)
      else
        flash[:report_error] = "Select a report type"
      end
    end
  end

  def generate_bill
    @clients = OutgoingReceipt.where(sale_type: 1).where.not(balance: 0).map(&:client).compact.uniq
    flash[:report_error] = @clients.present? ? "Select a Client to bill" : 'No available Client'
  end

  private
  def set_report_period
    if params[:period] == 'Monthly'
      year = params['report-month']['(1i)'].to_i
      month = params['report-month']['(2i)'].to_i
      return {type: 'monthly', month: month, year: year}
    else
      year = params['report-year']['(1i)'].to_i
    end

    if params[:period] == 'Quarterly'
      return {type: 'quarter', year: year, quarter: params[:quarter]}
    else
      return {type: 'annual', year: year}
    end
  end
end
