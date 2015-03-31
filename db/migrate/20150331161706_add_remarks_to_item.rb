class AddRemarksToItem < ActiveRecord::Migration
  def change
    add_column :items, :remarks, :string
  end
end
