class AddNameToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :name, :string, null: false
  end
end
