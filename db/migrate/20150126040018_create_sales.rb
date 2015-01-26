class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :type
      t.belongs_to :inventory, index:true
      t.belongs_to :receipt_detail, index:true
      t.timestamps
    end
  end
end
