class ChangeLogsController < ApplicationController
  before_action :authenticate_user!

  def new_menu_edit
    @menu = Menu.find(params[:menu_id])
    @place = Place.find(params[:place_id])
    @change_log = ChangeLog.new
  end

  def create_menu_edit
    menu = Menu.find(params[:menu_id])
    place = Place.find(params[:place_id])
    change_log = ChangeLog.new(change_log_params)
    change_log.changeable = menu
    change_log.user = current_user

    if change_log.user.role == 'admin'
      change_log.approve_menu_edit
      redirect_to place_url(place), notice: 'Ürün değişiklik isteği başarıyla onaylandı.'
    elsif change_log.save
      respond_to do |format|
        format.html do
          redirect_to place_url(place),
                      notice: 'Ürün değişiklik isteği başarıyla değerlendirmeye gönderildi.
                      Desteğiniz için teşekküre deriz 💚'
        end
      end
    else
      format.html { render :new_menu_edit, status: :unprocessable_entity }
    end
  end

  private

  def change_log_params
    params.require(:change_log).permit(
      :name, :vegan, :place_id, :user_id, :latitude, :longitude, :address, :phone,
      :web_url, :email, :facebook_url, :instagram_url, :twitter_url, :product_category,
      :description, :price, :image, tag_ids: [], images: [], deleted_images: [],
                                    contributors: []
    )
  end
end
