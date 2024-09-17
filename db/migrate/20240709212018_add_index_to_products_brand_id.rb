class AddIndexToProductsBrandId < ActiveRecord::Migration[7.1]
  def change
    add_index :products, :brand_id
  end
end
