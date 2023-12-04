class AddActiveToMenu < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :active, :boolean, default: true
  end
end
