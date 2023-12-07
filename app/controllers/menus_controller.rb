class MenusController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_menu, only: %i[show edit update destroy]
  before_action :set_place, only: %i[new edit update create destroy]

  def index
    @menus = Menu.all.with_attached_image
  end

  def new
    @menu = Menu.new
  end

  def create
    menu = @place.menus.create(menu_params)
    menu.contributors << current_user.id
    menu.image.attach(params[:menu][:image])
    menu.approved = true if current_user && current_user.role == 'admin'

    respond_to do |format|
      if menu.save
        format.html do
          redirect_to @place, notice: 'Eklediğiniz ürün değerlendirmeye gönderildi.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    change_log = ChangeLog.new(menu_params)
    change_log.image.attach(params[:menu][:image])
    change_log.changeable = @menu
    change_log.user = current_user

    respond_to do |format|
      if change_log.save
        change_log.approve_menu_edit if current_user.admin?
        format.html do
          redirect_to @place,
                      notice: 'Ürün değişiklik isteği başarıyla değerlendirmeye gönderildi.
                      Desteğiniz için teşekkür ederiz 💚'
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user.admin?
      @menu.active = false
      redirect_to @place, notice: 'Ürün başarıyla silindi.' if @menu.save
    else
      change_log = ChangeLog.new(active: false, changeable: @menu, user: current_user)
      if change_log.save
        redirect_to @place, notice: 'Ürün silme isteği başarıyla değerlendirmeye gönderildi.'
      else
        redirect_to @place, alert: 'Ürün silme isteği gönderilemedi.'
      end
    end
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def set_place
    @place = Place.find(params[:place_id])
  end

  def menu_params
    params.require(:menu).permit(:name, :description, :product_category, :place_id, :price, :image,
                                 contributors: [])
  end
end
