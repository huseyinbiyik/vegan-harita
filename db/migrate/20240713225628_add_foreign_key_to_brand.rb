class AddForeignKeyToBrand < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :products, :brands
  end
end
