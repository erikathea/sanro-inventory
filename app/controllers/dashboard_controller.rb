class DashboardController < ApplicationController
  def index
    @receipts = Receipt.all
  end
end
