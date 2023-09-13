class AddUserToChangeLogs < ActiveRecord::Migration[7.0]
  def change
    add_reference :change_logs, :user, null: false, foreign_key: true
  end
end
