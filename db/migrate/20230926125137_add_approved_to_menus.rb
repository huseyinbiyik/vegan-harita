class AddApprovedToMenus < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :approved, :boolean, default: false
  end
end
