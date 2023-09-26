class MenusController < ApplicationController
  before_action :set_menu, only: %i[show edit update destroy]

  def index
    @menus = Menu.all.with_attached_image
  end

  def show; end

  def new
    @menu = Menu.new
  end

  def edit; end

  def create
    @place = Place.find(params[:place_id])
    @menu = @place.menus.create(menu_params)
    @menu.contributors << current_user.id
    @menu.image.attach(params[:menu][:image])

    respond_to do |format|
      if @menu.save
        format.html do
          redirect_to place_menu_url(@place, @menu), notice: 'Eklediğiniz ürün değerlendirmeye gönderildi.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @menu.update(menu_params)
        format.html { redirect_to menu_url(@menu), notice: 'Menu was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @menu.destroy

    respond_to do |format|
      format.html { redirect_to menus_url, notice: 'Menu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_menu
    @menu = Menu.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name, :description, :product_category, :place_id, :price, :image,
                                 contributors: [])
  end
end
