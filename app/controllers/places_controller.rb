class PlacesController < ApplicationController
  before_action :set_place, only: %i[show edit update destroy]

  # GET /places or /places.json
  def index
    @places = Place.all
    respond_to do |format|
      format.html
      format.json { render json: @places.to_json(methods: :featured_image) }
    end
  end

  def search
    @places = if params[:name_search].present?
                @places = Place.filter_by_name(params[:name_search])
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

  # GET /places/1 or /places/1.json
  def show; end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit; end

  # POST /places or /places.json
  def create
    @place = Place.new(place_params)
    @place.images.attach(params[:place][:images])

    respond_to do |format|
      if @place.save
        format.html do
          redirect_to place_url(@place),
                      notice: 'Yeni mekan başarıyla değerlendirmeye gönderildi. Desteğiniz için teşekkür ederiz 💚'
        end
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1 or /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html do
          redirect_to place_url(@place),
                      notice: 'Güncelleme isteğiniz değerlendirmeye
                       başarıyla gönderildi.
                       Desteğiniz için teşekkür ederiz 💚'
        end
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1 or /places/1.json
  def destroy
    @place.destroy

    respond_to do |format|
      format.html do
        redirect_to places_url, notice: 'Mekan silme talebiniz başarıyla gönderildi. Desteğiniz için teşekkür ederiz 💚'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = Place.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def place_params
    params.require(:place).permit(:name, :address, :latitude, :longitude, :vegan, :image, :instagram_url,
                                  :facebook_url, :twitter_url, :web_url, :email, :phone)
  end
end
