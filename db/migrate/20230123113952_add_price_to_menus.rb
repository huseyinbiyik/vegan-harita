class AddPriceToMenus < ActiveRecord::Migration[7.0]
  def change
    add_column :menus, :price, :decimal
  end
end
