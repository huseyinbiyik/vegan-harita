class AddContributorsToMenus < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :contributors, :integer, array: true, default: []
  end
end
