class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :bar_code
      t.integer :type

      t.timestamps
    end
  end
end
