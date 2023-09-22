class MenusController < ApplicationController
  before_action :set_menu, only: %i[show edit update destroy]

  def index
    @menus = Menu.all.with_attached_menu_images
  end

  def show; end

  def new
    @menu = Menu.new
  end

  def edit; end

  def create
    @place = Place.find(params[:place_id])
    @menu = @place.menus.create(menu_params)
    @menu.menu_images.attach(params[:menu][:menu_images])

    respond_to do |format|
      if @menu.save
        format.html { redirect_to place_menu_url(@place, @menu), notice: 'Menu was successfully created.' }

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
    params.require(:menu).permit(:name, :description, :product_category, :place_id, :price, :menu_images)
  end
end
