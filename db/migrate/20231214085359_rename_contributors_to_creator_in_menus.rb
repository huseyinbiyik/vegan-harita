class RenameContributorsToCreatorInMenus < ActiveRecord::Migration[7.0]
  def change
    remove_column :menus, :contributors, :string
    add_reference :menus, :creator, foreign_key: { to_table: :users }
  end
end
