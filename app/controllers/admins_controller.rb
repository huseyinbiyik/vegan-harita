class AdminsController < ApplicationController # rubocop:disable Metrics/ClassLength
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

    @pending_reviews = Review.where(approved: false)
  end

  def approve_user
    user = User.find(params[:id])
    if user.approve
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = 'Kullanıcı onaylandı.'
          render turbo_stream: [
            turbo_stream.remove("user_#{params[:id]}"),
            turbo_stream.update('flash_messages', partial: 'shared/flash_messages', locals: { flash: })
          ]
        end
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
        format.turbo_stream do
          flash.now[:notice] = 'Mekan onaylandı'
          render turbo_stream: [
            turbo_stream.remove("place_#{params[:id]}"),
            turbo_stream.update('flash_messages', partial: 'shared/flash_messages', locals: { flash: })
          ]
        end
      end
    else
      redirect_to approvals_path, alert: 'Mekan onaylanamadı'
    end
  end

  def reject_place
    place = Place.find(params[:id])
    place.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = 'Mekan reddedildi.'
        render turbo_stream: [turbo_stream.remove("place_#{params[:id]}"),
                              turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                    locals: { flash: })]
      end
    end
  end

  def approve_place_edit
    place_edit = ChangeLog.find(params[:id])
    if place_edit.approve_place_edit
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = 'Mekan düzenlemesi onaylandı'
          render turbo_stream: [turbo_stream.remove("place_edit_#{place_edit.id}"),
                                turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                      locals: { flash: })]
        end
      end
    else
      redirect_to approvals_path, alert: 'Mekan düzenlemesi onaylanamadı'
    end
  end

  def reject_place_edit
    place_edit = ChangeLog.find(params[:id])
    place_edit.destroy

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = 'Mekan düzenlemesi reddedildi'
        render turbo_stream: [turbo_stream.remove("place_edit_#{place_edit.id}"),
                              turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                    locals: { flash: })]
      end
    end
  end

  def approve_menu
    menu = Menu.find(params[:id])
    menu.approve
    menu.creator.points += 1

    if menu.save && menu.creator.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = 'Menü onaylandı'
          render turbo_stream: [turbo_stream.remove("menu_#{params[:id]}"),
                                turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                      locals: { flash: })]
        end
      end
    else
      redirect_to approvals_path, alert: 'Menü onaylanamadı'
    end
  end

  def reject_menu
    menu = Menu.find(params[:id])
    menu.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = 'Menü reddedildi'
        render turbo_stream: [turbo_stream.remove("menu_#{params[:id]}"),
                              turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                    locals: { flash: })]
      end
    end
  end

  def approve_menu_edit
    menu_edit = ChangeLog.find(params[:id])
    if menu_edit.approve_menu_edit
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = 'Menü düzenlemesi onaylandı'
          render turbo_stream: [turbo_stream.remove("menu_edit_#{menu_edit.id}"),
                                turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                      locals: { flash: })]
        end
      end
    else
      redirect_to approvals_path, alert: 'Menü düzenlemesi onaylanamadı'
    end
  end

  def reject_menu_edit
    menu_edit = ChangeLog.find(params[:id])
    menu_edit.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = 'Menü düzenlemesi reddedildi'
        render turbo_stream: [turbo_stream.remove("menu_edit_#{menu_edit.id}"),
                              turbo_stream.update('flash_messages', partial: 'shared/flash_messages',
                                                                    locals: { flash: })]
      end
    end
  end

  def approve_review
    review = Review.find(params[:id])
    if review.approve
      review.user.points += 2
      review.user.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = 'Değerlendirme onaylandı'
          render turbo_stream: [turbo_stream.remove("review_#{params[:id]}"), turbo_stream.update('flash_messages',
                                                                                                  partial: 'shared/flash_messages',
                                                                                                  locals: { flash: })]
        end
      end
    else
      redirect_to approvals_path, alert: 'Değerlendirme onaylanamadı'
    end
  end

  def reject_review
    review = Review.find(params[:id])
    review.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = 'Değerlendirme reddedildi'
        render turbo_stream: [turbo_stream.remove("review_#{params[:id]}"), turbo_stream.update('flash_messages',
                                                                                                partial: 'shared/flash_messages',
                                                                                                locals: { flash: })]
      end
    end
  end

  private

  def authenticate_admin
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end
end
