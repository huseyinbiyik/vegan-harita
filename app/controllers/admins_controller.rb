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
    user.approved = true

    respond_to do |format|
      if user.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("user_#{user.id}")
        end
      else
        redirect_to approvals_path, alert: 'Kullanıcı onaylanamadı.'
      end
    end
  end

  def approve_place
    @place = Place.find(params[:id])
    @place.approved = true
    @place.save
    @place.creator = User.find(@place.contributors.first)
    @place.creator.points += 10
    @place.creator.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("place_#{params[:id]}")
      end
    end
  end

  def reject_place
    @place = Place.find(params[:id])
    @place.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("place_#{params[:id]}")
      end
    end
  end

  def approve_place_edit
    place_edit = ChangeLog.find(params[:id])
    place = Place.find(place_edit.changeable_id)
    %w[name longitude latitude address vegan instagram_url facebook_url twitter_url web_url email phone].each do |attr|
      place.send("#{attr}=", place_edit.send(attr)) if place_edit.send(attr).present?
    end
    place.tag_ids = place_edit.tag_ids if place_edit.tag_ids.present?
    place.images.attach(place_edit.images.map(&:blob)) if place_edit.images.attached?
    if place_edit.deleted_images.present?
      place_edit.deleted_images.each do |image|
        place.images.find(image).purge
      end
    end
    place.contributors << place_edit.user.id unless place.contributors.include?(place_edit.user.id)
    place.save
    place_edit.user.points += 1
    place_edit.user.save
    place_edit.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("place_edit_#{place_edit.id}")
      end
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
    @menu = Menu.find(params[:id])
    @menu.approved = true
    @menu.save
    @menu.creator = User.find(@menu.contributors.first)
    @menu.creator.points += 1
    @menu.creator.save

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("menu_#{params[:id]}")
      end
    end
  end

  def reject_menu
    @menu = Menu.find(params[:id])
    @menu.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("menu_#{params[:id]}")
      end
    end
  end

  def approve_menu_edit
    menu_edit = ChangeLog.find(params[:id])
    menu = Menu.find(menu_edit.changeable_id)

    %w[name description product_category price].each do |attr|
      menu.send("#{attr}=", menu_edit.send(attr))
    end
    menu.image.purge if menu_edit.image.attached?
    menu.image.attach(menu_edit.image.blob) if menu_edit.image.attached?

    menu.contributors << menu_edit.user.id unless menu.contributors.include?(menu_edit.user.id)
    menu.save
    menu_edit.user.points += 1
    menu_edit.user.save
    menu_edit.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("menu_edit_#{menu_edit.id}")
      end
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
