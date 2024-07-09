class AddStatusToProduct < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :status, :boolean, default: false
  end
end
