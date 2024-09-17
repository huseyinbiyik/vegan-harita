class AddProductCategoryToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :product_category, null: false, foreign_key: true
  end
end
