class PlacesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show search]
  before_action :set_place, only: %i[show edit update]
  before_action :record_visit, only: [ :show ]

  def index
    north = params[:north].to_f
    south = params[:south].to_f
    east = params[:east].to_f
    west = params[:west].to_f

    @places = Place.approved.where(latitude: south..north, longitude: west..east).includes(:images_attachments)

    @last_ten_places = Place.approved.order(created_at: :desc).limit(10)
    respond_to do |format|
      format.html
      format.json { render json: @places.as_json(except: :email, methods: :featured_image) }
    end
  end



  def search
    if params[:name_search].present? && params[:name_search].length > 2
      @places = Place.approved.filter_by_name(params[:name_search])
      @location_predictions = Geocoder.search(params[:name_search])
    else
      []
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("search-results", partial: "places/search_results",
                                                 locals: { places: @places, location_predictions: @location_predictions })
      end
    end
  end

  def show
    redirect_to root_path, notice: t("controllers.places.not_approved") unless @place.approved? || current_user&.admin?
    @reviews = @place.reviews.order(created_at: :desc).with_attached_images
    @contributors = User.where(id: @place.contributors)
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    @place.contributors << current_user.id unless @place.contributors.include?(current_user.id)
    @place.update(status: :approved) if current_user.admin?

    respond_to do |format|
      if @place.save
        format.html do
          redirect_to root_path,
                      notice: t("controllers.places.create.success")
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
          flash.now[:notice] = t("controllers.places.update.success")
          render turbo_stream: turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                   locals: { flash: })
        end
      else
        format.turbo_stream do
          flash.now[:alert] = t("controllers.places.update.failure")
          render turbo_stream: turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                   locals: { flash: })
        end
      end
    end
  end

  private

  def set_place
    @place = Place.find_by(slug: params[:slug])
  end

  def place_params
    params.require(:place).permit(
      :name, :address, :latitude, :longitude, :place_id, :vegan, :instagram_handle,
      :facebook_handle, :x_handle, :web_url, :email, :phone, :status, tag_ids: [], contributors: [], images: []
    )
  end

  def change_log_params
    params.require(:change_log).permit(:name, :address, :latitude, :longitude, :place_id, :vegan, :instagram_handle,
                                       :facebook_handle, :x_handle, :web_url, :phone, :status, tag_ids: [],
                                       contributors: [], images: [], deleted_images: []) # rubocop:disable Layout/LineLength
  end

  def record_visit
    @place.visits.create unless current_user&.admin? || current_user&.places&.include?(@place)
  end
end
