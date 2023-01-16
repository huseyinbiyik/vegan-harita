class AddFullyVeganToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :fully_vegan, :boolean
  end
end
