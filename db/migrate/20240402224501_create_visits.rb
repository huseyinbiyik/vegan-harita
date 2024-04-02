class CreateVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :visits do |t|
      t.references :place, null: false, foreign_key: true
      t.datetime :created_at, null: false
    end
  end
end
