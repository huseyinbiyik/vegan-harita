class MigratePlaceIdToPolymorphic < ActiveRecord::Migration[7.1]
  def change
    Review.find_each do |review|
      review.update(reviewable_type: 'Place', reviewable_id: review.place_id)
    end
  end
end
