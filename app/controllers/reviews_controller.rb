class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: %i[edit update destroy]
  before_action :set_place, only: %i[new edit create update destroy]

  def new
    @review = Review.new
  end

  def edit; end

  def create
    @review = @place.reviews.build(review_params)
    @review.user = current_user
    respond_to do |format|
      if @review.save
        format.turbo_stream do
          flash.now[:notice] = t('controllers.reviews.create.success')
          render turbo_stream: turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                     locals: { flash: })
        end
      else
        render format.turbo_stream do
          flash.now[:alert] = t('controllers.reviews.create.failure')
          render turbo_stream: turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                     locals: { flash: })
        end
      end
    end
  end

  def update
    if @review.update(review_params)
      flash.now[:notice] = t('controllers.reviews.update.success')
      render turbo_stream: turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                 locals: { flash: })
    else
      redirect_to @place, alert: t('controllers.reviews.update.failure')
    end
  end

  def destroy
    if @review.destroy
      redirect_to @place, notice: t('controllers.reviews.destroy.success')
    else
      redirect_to @place, alert: t('controllers.reviews.destroy.failure')
    end
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
