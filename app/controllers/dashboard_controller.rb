class DashboardController < ApplicationController
  before_action :authorized?, except: [:index]
  def index
  end

  def generate_report
    if params[:report] == 'Stocks'
      redirect_to stock_report_path()
    end

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

  def generate_bill
    @clients = OutgoingReceipt.where('balance > 0').map(&:client).compact.uniq
    flash[:report_error] = @clients.present? ? "Select a Client to bill" : 'No available Client'
  end

  def archive
    @header = params[:report]
    if params[:report] == 'Stocks'
      @details = File.open('data/latest-listofstocks.csv').readlines
    elsif params[:report] == 'Delivery Inventory'
      @details = File.open('data/delivery.csv').readlines
    elsif params[:report] == 'Delivery (DR)'
      @details = File.open('data/latest-dr.csv').readlines
    elsif params[:report] == 'Sale Invoice (SI)'
      @details = File.open('data/latest-si.csv').readlines
    end
  end

  private
  def authorized?
    unless current_user.is_admin.present?
      raise Pundit::NotAuthorizedError
    end
  end

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
