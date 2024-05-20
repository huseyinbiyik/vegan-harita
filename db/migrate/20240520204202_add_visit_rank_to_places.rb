class AddVisitRankToPlaces < ActiveRecord::Migration[7.1]
  def change
    add_column :places, :visit_rank, :integer, default: 0, null: false
  end
end
