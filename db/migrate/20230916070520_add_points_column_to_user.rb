class AddPointsColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :points, :integer, default: 0
  end
end
