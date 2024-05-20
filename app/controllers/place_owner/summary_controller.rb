class PlaceOwner::SummaryController < ApplicationController
  include PlaceOwner::PlaceOwnerVerification

  def show
    @place = Place.includes(reviews: :images, menus: :likes).find_by(slug: params[:slug])
    @place_count = Place.count
    @reviews = @place.reviews.order(created_at: :desc)
    @most_liked_product = @place.menus.joins(:likes).group("menus.id").order(Arel.sql("count(likes.id) DESC")).first || nil

    @visits = @place.visits.where("created_at >= ?", 1.year.ago)

    @visits_count_by_month = @visits.group("TO_CHAR(created_at, 'Mon YYYY')")
                                    .order(Arel.sql("min(created_at)"))
                                    .count

    @visits_count_by_day = @visits.where("created_at >= ?", 1.month.ago)
                                  .group("TO_CHAR(created_at, 'DD Mon YYYY')")
                                  .order(Arel.sql("min(created_at)"))
                                  .count

    UpdateVisitRankJob.perform_later
  end
end
