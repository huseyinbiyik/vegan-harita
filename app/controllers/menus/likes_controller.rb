class Menus::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_menu

  def update
    if @menu.liked_by?(current_user)
      @menu.unlike(current_user)
    else
      @menu.like(current_user)
    end
  end

  private

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end
end
