class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.belongs_to :item, index:true
      t.decimal :unit_price, precision: 15, scale:2
      t.float :current_stock
      t.timestamps
    end
  end
end
