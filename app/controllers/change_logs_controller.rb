class ChangeLogsController < ApplicationController
  def create
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

  def new
    @place = Place.find(params[:id])
    @change_log = ChangeLog.new
  end

  private

  def change_log_params
    params.require(:change_log).permit(:name, :vegan, :place_id, :user_id, :latitude, :longitude, :address, :phone,
                                       :web_url, :email, :facebook_url, :instagram_url, :twitter_url, tag_ids: [], images: [], deleted_images: [])
  end
end
