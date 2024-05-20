class PlaceOwner::SummaryController < ApplicationController
  include PlaceOwner::PlaceOwnerVerification

  def show
    @place = Place.find_by(slug: params[:slug])
    @reviews = @place.reviews.order(created_at: :desc).with_attached_images
    @most_liked_product = @place.menus.joins(:likes).group("menus.id").order("count(likes.id) DESC").first || nil
    @visits_by_month = @place.visits.where("created_at >= ?", 1.year.ago).group_by { |visit| visit.created_at.strftime("%b %Y") }
    @visits_count_by_month = @visits_by_month.transform_values(&:count)
    @visits_by_day = @place.visits.where("created_at >= ?", 1.month.ago).group_by { |visit| visit.created_at.strftime("%d %b %Y") }
    @visits_count_by_day = @visits_by_day.transform_values(&:count)
=begin
To calculate the place's rank
@places = Place.all.includes(:visits)
@place_count = Place.count
sorted_places = @places.sort_by { |place| place.visits_count_for_current_month }.reverse
@place_visit_rank = sorted_places.map { |place| place.visits_count_for_current_month }.uniq.show(@place.visits_count_for_current_month) + 1
=end
  end
end
