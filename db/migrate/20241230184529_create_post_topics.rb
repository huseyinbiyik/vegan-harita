class CreatePostTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :post_topics do |t|
      t.string :title, null: false
      t.integer :posts_count, default: 0, null: false

      t.timestamps
    end
  end
end
