class PlaceEdits < ActiveRecord::Migration[7.0]
  def change
    create_table :place_edits do |t|
      t.references :place, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.float :longitude
      t.float :latitude
      t.text :address
      t.boolean :vegan
      t.string :instagram_url
      t.string :facebook_url
      t.string :twitter_url
      t.string :web_url
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
