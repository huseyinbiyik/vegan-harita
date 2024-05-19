class AddNoteToClaim < ActiveRecord::Migration[7.1]
  def change
    add_column :claims, :note, :text
  end
end
