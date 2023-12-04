class MenusController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @menus = Menu.all.with_attached_image
  end

  def new
    @menu = Menu.new
    @place = Place.find(params[:place_id])
  end

  def create
    place = Place.find(params[:place_id])
    menu = place.menus.create(menu_params)
    menu.contributors << current_user.id
    menu.image.attach(params[:menu][:image])
    menu.approved = true if current_user && current_user.role == 'admin'

    respond_to do |format|
      if menu.save
        format.html do
          redirect_to place_url(place), notice: 'Eklediğiniz ürün değerlendirmeye gönderildi.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @menu = Menu.find(params[:id])
    @place = Place.find(params[:place_id])
  end

  def update
    menu = Menu.find(params[:id])
    place = Place.find(params[:place_id])
    change_log = ChangeLog.new(menu_params)
    change_log.image.attach(params[:menu][:image])
    change_log.changeable = menu
    change_log.user = current_user

    respond_to do |format|
      if change_log.save
        change_log.approve_menu_edit if current_user.admin?
        format.html do
          redirect_to place_url(place),
                      notice: 'Ürün değişiklik isteği başarıyla değerlendirmeye gönderildi.
                      Desteğiniz için teşekkür ederiz 💚'
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def menu_params
    params.require(:menu).permit(:name, :description, :product_category, :place_id, :price, :image,
                                 contributors: [])
  end
end
