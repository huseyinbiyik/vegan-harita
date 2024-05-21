class AddSlugToPlaces < ActiveRecord::Migration[7.1]
  def change
    add_column :places, :slug, :string
    add_index :places, :slug, unique: true
  end
end
