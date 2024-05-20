class ChangeEmailToStatusInClaim < ActiveRecord::Migration[7.1]
  def change
    remove_column :claims, :email, :string
    add_column :claims, :status, :integer, default: 0
  end
end
