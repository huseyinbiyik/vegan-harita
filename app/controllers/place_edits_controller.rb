class PlaceEditsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_place, only: %i[create approve]
  before_action :set_place_edit, only: %i[destroy approve]

  def create
    @place_edit = PlaceEdit.create(place_edit_params)
    @place_edit.place = @place
    @place_edit.user = current_user

    respond_to do |format|
      if @place_edit.save
        format.html do
          redirect_to place_url(@place),
                      notice: 'Mekan düzenleme isteği başarıyla değerlendirmeye gönderildi. Desteğiniz için teşekkür ederiz 💚'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def new
    @place = Place.new
    @place_edit = PlaceEdit.new
  end

  def approve
    @place.name = @place_edit.name
    @place.longitude = @place_edit.longitude
    @place.latitude = @place_edit.latitude
    @place.address = @place_edit.address
    @place.vegan = @place_edit.vegan
    @place.instagram_url = @place_edit.instagram_url
    @place.facebook_url = @place_edit.facebook_url
    @place.twitter_url = @place_edit.twitter_url
    @place.web_url = @place_edit.web_url
    @place.email = @place_edit.email
    @place.phone = @place_edit.phone
    @place.contributors << @place_edit.user.id
    @place.save
    @place_edit.destroy
    respond_to do |format|
      format.html do
        redirect_to place_url(@place),
                    notice: 'Mekanı onayladın.'
      end
    end
  end

  def destroy
    @place_edit.destroy
    respond_to do |format|
      format.html do
        redirect_to place_url(@place_edit.place),
                    notice: 'Mekan düzenleme isteği başarıyla silindi.'
      end
    end
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def set_place_edit
    @place_edit = PlaceEdit.find(params[:id])
  end

  def place_edit_params
    params.require(:place).permit(:name, :address, :latitude, :longitude, :vegan, :image, :instagram_url,
                                  :facebook_url, :twitter_url, :web_url, :email, :phone, :user_id, :place_id)
  end
end

