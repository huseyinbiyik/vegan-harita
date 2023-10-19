class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: %i[edit update destroy]

  def new
    @review = Review.new
  end

  def edit; end

  def create
    @place = Place.find(params[:place_id])
    @review = @place.reviews.build(review_params)
    @review.user = current_user
    @review.save
  end

  def update
    @review.update(review_params)
  end

  def destroy
    @review.destroy
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :content, :feedback, :approved, images: [])
  end
end
