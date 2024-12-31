class CreatePostComments < ActiveRecord::Migration[7.1]
  def change
    create_table :post_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.boolean :approved, default: false, null: false
      t.integer :likes_count, default: 0, null: false

      t.timestamps
    end
  end
end
