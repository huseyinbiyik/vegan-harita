class ChangeStatusToConfirmedInProduct < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :status, :confirmed
  end
end
