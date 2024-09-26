class CreateJoinTableProductsShops < ActiveRecord::Migration[7.1]
  def change
    create_join_table :products, :shops do |t|
      t.index [ :product_id, :shop_id ]
      t.index [ :shop_id, :product_id ]
    end
  end
end
