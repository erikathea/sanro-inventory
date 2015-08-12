class MergeTransaction < ActiveRecord::Base
  belongs_to :mergeable, polymorphic: true
  belongs_to :merge_item
end