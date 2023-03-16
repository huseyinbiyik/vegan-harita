class ChangeFullyVeganToVegan < ActiveRecord::Migration[7.0]
  def change
    rename_column :places, :fully_vegan, :vegan
  end
end
