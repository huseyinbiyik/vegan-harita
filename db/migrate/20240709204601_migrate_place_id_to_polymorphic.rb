class RemovePlaceIdFromReviews < ActiveRecord::Migration[7.1]
  def change
    remove_column :reviews, :place_id, :bigint
  end
end
