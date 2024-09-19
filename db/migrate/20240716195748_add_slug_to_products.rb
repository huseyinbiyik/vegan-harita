class AddSlugToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :slug, :string, null: false
    add_index :products, :slug, unique: true
  end
end
