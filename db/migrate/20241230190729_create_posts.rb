class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.boolean :approved, default: false, null: false
      t.references :user, null: false, foreign_key: true
      t.references :post_topic, null: false, foreign_key: true
      t.integer :likes_count, default: 0, null: false

      t.timestamps
    end

    add_index :posts, :slug, unique: true
  end
end
