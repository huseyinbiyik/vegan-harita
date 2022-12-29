class RenameColumnInTable < ActiveRecord::Migration[7.0]
  def change
    rename_column :places, :latitude, :lat
    rename_column :places, :longitude, :lng
  end
end
