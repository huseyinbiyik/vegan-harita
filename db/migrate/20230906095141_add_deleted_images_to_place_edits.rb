class AddDeletedImagesToPlaceEdits < ActiveRecord::Migration[7.0]
  def change
    add_column :place_edits, :deleted_images, :integer, array: true, default: []
  end
end
