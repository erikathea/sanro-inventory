class AddItemToReceiptDetail < ActiveRecord::Migration
  def change
    add_column :receipt_details, :description, :string
    add_column :receipt_details, :part_number, :string
  end
end
