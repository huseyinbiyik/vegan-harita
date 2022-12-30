class AddAddressToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :address, :text
  end
end
