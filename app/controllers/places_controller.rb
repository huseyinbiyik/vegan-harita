class PlacesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show search]
  before_action :set_place, only: %i[show edit update]

  def index
    @places = Place.approved
    respond_to do |format|
      format.html
      format.json { render json: @places.to_json(methods: :featured_image) }
    end
  end

  def search
    @places = if params[:name_search].present?
                @places = Place.approved.filter_by_name(params[:name_search])
              else
                []
              end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update('search-results', partial: 'places/search_results',
                                                                   locals: { places: @places })
      end
    end
  end

  def show
    redirect_to root_path, notice: t('controllers.places.not_approved') unless @place.approved || current_user&.admin?
    @reviews = @place.reviews.order(created_at: :desc).with_attached_images
    @contributors = User.where(id: @place.contributors).with_attached_avatar
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    @place.contributors << current_user.id
    @place.approved = true if current_user&.admin?

    respond_to do |format|
      if @place.save
        format.html do
          redirect_to root_path,
                      notice: t('controllers.places.create.success')
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @change_log = ChangeLog.new
  end

  def update
    @change_log = ChangeLog.new(change_log_params)
    @change_log.changeable = @place
    @change_log.user = current_user

    respond_to do |format|
      if @change_log.save
        @change_log.approve_place_edit if current_user.admin?
        format.turbo_stream do
          flash.now[:notice] = t('controllers.places.update.success')
          render turbo_stream: turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                     locals: { flash: })
        end
      else
        format.turbo_stream do
          flash.now[:alert] = t('controllers.places.update.failure')
          render turbo_stream: turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                     locals: { flash: })
        end
      end
    end
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(
      :name, :address, :latitude, :longitude, :vegan, :instagram_handle,
      :facebook_handle, :x_handle, :web_url, :email, :phone, :approved, tag_ids: [], contributors: [], images: []
    )
  end

  def change_log_params
    params.require(:change_log).permit(:name, :address, :latitude, :longitude, :vegan, :instagram_handle,
                                       :facebook_handle, :x_handle, :web_url, :email, :phone, :approved, tag_ids: [],
                                                                                                         contributors: [], images: [], deleted_images: []) # rubocop:disable Layout/LineLength
  end
end
