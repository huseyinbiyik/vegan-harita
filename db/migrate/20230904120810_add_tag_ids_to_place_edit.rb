class AddTagIdsToPlaceEdit < ActiveRecord::Migration[7.0]
  def change
    add_column :place_edits, :tag_ids, :integer, array: true, default: []
  end
end
