class CreateChangeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :change_logs do |t|
      t.jsonb :data, null: false, default: {}
      t.references :changeable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
