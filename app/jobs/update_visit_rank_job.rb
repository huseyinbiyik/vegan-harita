class UpdateVisitRankJob < ApplicationJob
  queue_as :default

  def perform(*args)
    visit_counts = Visit.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)
                        .group(:place_id)
                        .count

    sorted_places = Place.all.sort_by { |place| visit_counts[place.id] || 0 }.reverse

    sorted_places.each_with_index do |place, index|
      place.update(visit_rank: index + 1)
    end
  end
end
