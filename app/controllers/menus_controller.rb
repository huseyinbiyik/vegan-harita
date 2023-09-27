class MenusController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @menus = Menu.all.with_attached_image
  end

  def new
    @menu = Menu.new
  end

  def create
    @place = Place.find(params[:place_id])
    @menu = @place.menus.create(menu_params)
    @menu.contributors << current_user.id
    @menu.image.attach(params[:menu][:image])

    respond_to do |format|
      if @menu.save
        format.html do
          redirect_to place_url(@place), notice: 'Eklediğiniz ürün değerlendirmeye gönderildi.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def menu_params
    params.require(:menu).permit(:name, :description, :product_category, :place_id, :price, :image,
                                 contributors: [])
  end
end
