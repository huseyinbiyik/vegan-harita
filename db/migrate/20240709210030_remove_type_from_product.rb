class RemoveTypeFromProduct < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :type, :integer
  end
end
