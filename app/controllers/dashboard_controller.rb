class DashboardController < ApplicationController
  def index
    @inventories = Inventory.all
  end
end
