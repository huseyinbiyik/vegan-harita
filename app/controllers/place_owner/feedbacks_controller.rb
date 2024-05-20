class PlaceOwner::FeedbacksController < ApplicationController
  include PlaceOwner::PlaceOwnerVerification

  def show
    @place = Place.find_by(slug: params[:slug])
    @reviews = @place.reviews.order(created_at: :desc).with_attached_images
  end
end
