class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: %i[edit update destroy]
  before_action :set_place, only: %i[new edit create update]

  def new
    @review = Review.new
  end

  def edit; end

  def create
    @review = @place.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      redirect_to place_url(@place), notice: 'Değerlendirmeniz başarıyla kaydedildi.'
    else
      redirect_to place_url(@place), notice: 'Değerlendirmeniz kaydedilemedi.'
    end
  end

  def update
    if @review.update(review_params)
      redirect_to [@place, @review], notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_place
    @place = Place.find(params[:place_id])
  end

  def review_params
    params.require(:review).permit(:rating, :content, :feedback, :approved, images: [])
  end
end
