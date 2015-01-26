class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :description
      t.string :part_number
      t.decimal :selling_price, precision: 15, scale:2
      t.timestamps null: false
    end
  end
end
