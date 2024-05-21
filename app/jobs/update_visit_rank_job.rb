class UpdateVisitRankJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sorted_places = Place.all.sort_by { |place| place.visits_count_for_current_month }.reverse
    sorted_places.each_with_index do |place, index|
      place.update(visit_rank: index + 1)
    end
  end
end
