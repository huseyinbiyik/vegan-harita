class AddLikesCountToMenu < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :likes_count, :integer, default: 0
  end
end
