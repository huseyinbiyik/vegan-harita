class RenameConfirmedToApprovedInProducts < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :confirmed, :approved
  end
end
