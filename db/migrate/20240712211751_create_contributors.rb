class CreateContributors < ActiveRecord::Migration[7.1]
  def change
    create_table :contributors do |t|
      t.references :contributable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
    end
  end
end
