class CreateJoinTablePlaceTag < ActiveRecord::Migration[7.0]
  def change
    create_join_table :places, :tags do |t|
      t.index [:place_id, :tag_id]
      t.index [:tag_id, :place_id]
    end
  end
end
