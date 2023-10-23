class Menus::LikesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_menu

  def update
    if @menu.liked_by?(current_user)
      @menu.unlike(current_user)
    else
      @menu.like(current_user)
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@menu, :likes), partial: 'menus/likes',
                                                                         locals: { place: @menu.place, menu: @menu })
      end
    end
  end

  private

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end
end
