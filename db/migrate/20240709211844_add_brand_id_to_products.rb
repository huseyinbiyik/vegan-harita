class AddBrandIdToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :brand_id, :bigint
  end
end
