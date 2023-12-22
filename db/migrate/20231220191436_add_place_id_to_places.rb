class AddPlaceIdToPlaces < ActiveRecord::Migration[7.1]
  def change
    add_column :places, :place_id, :string
  end
end
