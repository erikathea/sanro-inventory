class ChangeTypeColumn < ActiveRecord::Migration
  def change
    rename_column :receipts, :type, :receipt_type
    rename_column :sales, :type, :sales_type
  end
end
