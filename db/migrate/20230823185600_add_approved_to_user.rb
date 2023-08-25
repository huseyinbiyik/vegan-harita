class AddApprovedToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :approved, :boolean, default: false
  end
end
