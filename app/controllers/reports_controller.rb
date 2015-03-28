class ReportsController < ApplicationController
  def stocks
    @title = 'List of Stocks'
    @inventories = Inventory.includes(:item).order('items.description').where('current_stock > 0')
  end

  def deliveries
  end

  def drs
  end

  def sis
  end
end