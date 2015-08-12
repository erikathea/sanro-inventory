class CreateMergeItems < ActiveRecord::Migration
  def change
    create_table :merge_items do |t|
      t.integer :from
      t.integer :to

      t.timestamps
    end
  end
end
