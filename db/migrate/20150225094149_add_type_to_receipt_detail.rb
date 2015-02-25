class AddTypeToReceiptDetail < ActiveRecord::Migration
  def change
  	add_column :receipt_details, :type, :string
  end
end
