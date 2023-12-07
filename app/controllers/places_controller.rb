class PlacesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show search]
  before_action :set_place, only: %i[show]

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
    @reviews = @place.reviews.order(created_at: :desc).with_attached_images
    return unless @place.approved == false

    redirect_to places_path, notice: 'Mekan henüz onaylanmadı. Onaylandığında burada olacak.'
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    @place.contributors << current_user.id
    @place.approved = true if current_user && current_user.role == 'admin'

    respond_to do |format|
      if @place.save
        format.html do
          redirect_to place_url(@place),
                      notice: 'Yeni mekan başarıyla değerlendirmeye gönderildi. Desteğiniz için teşekkür ederiz 💚'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    place = Place.find(params[:id])
    change_log = ChangeLog.new(place_params)
    change_log.deleted_images = params[:place][:deleted_images]
    change_log.changeable = place
    change_log.user = current_user

    respond_to do |format|
      if change_log.save
        change_log.approve_place_edit if current_user.admin?
        format.html do
          redirect_to place_url(place),
                      notice: 'Mekan değişiklik isteği başarıyla değerlendirmeye gönderildi.
                      Desteğiniz için teşekkür ederiz 💚'
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(
      :name, :address, :latitude, :longitude, :vegan, :instagram_url,
      :facebook_url, :twitter_url, :web_url, :email, :phone, :approved, tag_ids: [], contributors: [], images: []
    )
  end
end
