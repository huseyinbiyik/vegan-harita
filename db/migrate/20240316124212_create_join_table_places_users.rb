class CreateJoinTablePlacesUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :places, :users do |t|
      t.index [ :place_id, :user_id ]
      t.index [ :user_id, :place_id ]
    end
  end
end
