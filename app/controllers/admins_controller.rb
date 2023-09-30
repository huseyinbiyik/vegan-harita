class AdminsController < ApplicationController
  before_action :authenticate_admin

  def approvals
    @users = User.all
    @pending_users = User.where(approved: false).order('created_at DESC')

    @change_logs = ChangeLog.all.order('created_at DESC')
    @pending_place_edits = @change_logs.where(changeable_type: 'Place')
    @pending_menu_edits = @change_logs.where(changeable_type: 'Menu')

    @pending_places = Place.where(approved: false)
    @pending_places.each do |place|
      place.creator = @users.find(place.contributors.first)
      place.save
    end

    @pending_menus = Menu.where(approved: false)
    @pending_menus.each do |menu|
      menu.creator = @users.find(menu.contributors.first)
      menu.save
    end
  end

  def approve_user
    user = User.find(params[:id])
    if user.approve
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("user_#{user.id}") }
      end
    else
      redirect_to approvals_path, alert: 'Kullanıcı onaylanamadı.'
    end
  end

  def approve_place
    place = Place.find(params[:id])
    if place.approve
      place.creator = User.find(place.contributors.first)
      place.creator.points += 10
      place.creator.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("place_#{params[:id]}") }
      end
    else
      redirect_to approvals_path, alert: 'Mekan onaylanamadı.'
    end
  end

  def reject_place
    place = Place.find(params[:id])
    place.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("place_#{params[:id]}")
      end
    end
  end

  def approve_place_edit
    place_edit = ChangeLog.find(params[:id])
    if place_edit.approve_place_edit
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("place_edit_#{place_edit.id}")
        end
      end
    else
      redirect_to approvals_path, alert: 'Mekan düzenlemesi onaylanamadı.'
    end
  end

  def reject_place_edit
    place_edit = ChangeLog.find(params[:id])
    place_edit.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("place_edit_#{place_edit.id}")
      end
    end
  end

  def approve_menu
    menu = Menu.find(params[:id])
    if menu.approve
      menu.creator = User.find(menu.contributors.first)
      menu.creator.points += 1
      menu.creator.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("menu_#{params[:id]}")
        end
      end
    else
      redirect_to approvals_path, alert: 'Menü onaylanamadı.'
    end
  end

  def reject_menu
    menu = Menu.find(params[:id])
    menu.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("menu_#{params[:id]}")
      end
    end
  end

  def approve_menu_edit
    menu_edit = ChangeLog.find(params[:id])
    if menu_edit.approve_menu_edit
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("menu_edit_#{menu_edit.id}")
        end
      end
    else
      redirect_to approvals_path, alert: 'Menü düzenlemesi onaylanamadı.'
    end
  end

  def reject_menu_edit
    menu_edit = ChangeLog.find(params[:id])
    menu_edit.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("menu_edit_#{menu_edit.id}")
      end
    end
  end

  private

  def authenticate_admin
    redirect_to root_path unless user_signed_in? && current_user.role == 'admin'
  end
end
