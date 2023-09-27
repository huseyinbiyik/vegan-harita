class ChangeLogsController < ApplicationController
  before_action :authenticate_user!

  def new_place_edit
    @place = Place.find(params[:id])
    @change_log = ChangeLog.new
  end

  def create_place_edit
    @place = Place.find(params[:id])
    @change_log = ChangeLog.new(change_log_params)
    @change_log.changeable = @place
    @change_log.user = current_user

    respond_to do |format|
      if @change_log.save
        format.html do
          redirect_to place_url(@place),
                      notice: 'Mekan değişiklik isteği başarıyla değerlendirmeye gönderildi. Desteğiniz için teşekkür ederiz 💚'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def new_menu_edit
    @menu = Menu.find(params[:menu_id])
    @place = Place.find(params[:place_id])
    @change_log = ChangeLog.new
  end

  def create_menu_edit
    @menu = Menu.find(params[:menu_id])
    @place = Place.find(params[:place_id])
    @change_log = ChangeLog.new(change_log_params)
    @change_log.changeable = @menu
    @change_log.user = current_user

    respond_to do |format|
      if @change_log.save
        format.html do
          redirect_to place_url(@place),
                      notice: 'Ürün değişiklik isteği başarıyla değerlendirmeye gönderildi. Desteğiniz için teşekkür ederiz 💚'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def change_log_params
    params.require(:change_log).permit(:name, :vegan, :place_id, :user_id, :latitude, :longitude, :address, :phone,
                                       :web_url, :email, :facebook_url, :instagram_url, :twitter_url, :product_category, :description, :price, :image, tag_ids: [], images: [], deleted_images: [], contributors: [])
  end
end
