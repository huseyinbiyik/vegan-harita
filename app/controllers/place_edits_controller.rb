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
    @place.update(@place_edit.attributes.except('place_id', 'user_id', 'id').merge(contributors: [@place_edit.user.id]))
    @place_edit.destroy
    respond_to do |format|
      format.html do
        redirect_to place_url(@place),
                    notice: 'Mekan değişikliklerini onayladın.'
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