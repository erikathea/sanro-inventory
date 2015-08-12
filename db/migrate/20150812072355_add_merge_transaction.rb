class AddMergeTransaction < ActiveRecord::Migration
  def change
     create_table :merge_transactions do |t|
      t.belongs_to :merge_item, index: true
      t.references :mergeable, polymorphic: true, index: true
      t.timestamps null: false
     end
  end
end
