class DashboardController < ApplicationController
  def index
    @inventories = Inventory.all
  end

  def generate_report
    if params[:report] == 'Stocks'
      redirect_to stock_report_path()
    else

    end
  end
end
