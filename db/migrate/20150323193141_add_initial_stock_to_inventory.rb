class AddInitialStockToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :initial_stock, :float
  end
end
