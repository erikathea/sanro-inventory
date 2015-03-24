class DashboardController < ApplicationController
  def index
    @inventories = Inventory.all
  end

  def generate_report
  end
end
