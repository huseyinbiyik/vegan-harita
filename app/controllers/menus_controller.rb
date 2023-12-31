class MenusController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :set_menu, only: %i[edit update destroy]
  before_action :set_place, only: %i[new edit update create destroy]

  def index
    @menus = Menu.all.with_attached_image
  end

  def new
    @menu = Menu.new
  end

  def create
    menu = @place.menus.create(menu_params)
    menu.creator = current_user
    menu.approved = true if current_user&.admin?

    respond_to do |format|
      if menu.save && @place.save
        format.turbo_stream do
          flash.now[:notice] = t("controllers.menus.create.success")
          render turbo_stream: turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                                     locals: { flash: })
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    change_log = ChangeLog.new(menu_params)
    change_log.changeable = @menu
    change_log.user = current_user

    respond_to do |format|
      if change_log.save
        change_log.approve_menu_edit if current_user.admin?
        format.turbo_stream do
          flash.now[:notice] = t("controllers.menus.update.success")
          render turbo_stream: turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                                     locals: { flash: })
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user.admin?
      @menu.active = false
      redirect_to @place, notice: "Ürün başarıyla silindi." if @menu.save
    else
      change_log = ChangeLog.new(active: false, changeable: @menu, user: current_user)
      if change_log.save
        respond_to do |format|
          format.turbo_stream do
            flash.now[:notice] = t("controllers.menus.destroy.success")
            render turbo_stream: turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                                       locals: { flash: })
          end
        end
      else
        redirect_to @place, alert: t("controllers.menus.destroy.failure")
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
    params.require(:menu).permit(:name, :description, :product_category, :place_id, :price, :image)
  end
end
