class AddFromInventoryToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :inventory_id, :integer
    add_index :inventories, :inventory_id
  end
end
