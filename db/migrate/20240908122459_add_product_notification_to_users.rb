class AddProductNotificationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :allow_product_notification, :boolean, default: false
  end
end
