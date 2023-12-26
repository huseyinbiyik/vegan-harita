class AddAdminNoteToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin_note, :text
  end
end
