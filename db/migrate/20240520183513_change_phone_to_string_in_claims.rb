class ChangePhoneToStringInClaims < ActiveRecord::Migration[7.1]
  def change
    change_column :claims, :phone, :string
  end
end
