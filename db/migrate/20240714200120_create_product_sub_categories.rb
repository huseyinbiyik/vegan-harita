class CreateProductSubCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :product_sub_categories do |t|
      t.references :product_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
