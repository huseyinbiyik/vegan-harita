class ChangeRoleToTitleInClaims < ActiveRecord::Migration[7.1]
  def change
    rename_column :claims, :role, :title
  end
end
