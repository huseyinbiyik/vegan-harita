class AdminsController < ApplicationController # rubocop:disable Metrics/ClassLength
  before_action :authenticate_admin

  def approvals
    @pending_claims = Claim.all.order("created_at DESC").pending
    @users = User.all.with_attached_avatar
    @pending_users = @users.where(approved: false).order("created_at DESC")

    @change_logs = ChangeLog.all.order("created_at DESC")
    @pending_place_edits = @change_logs.where(changeable_type: "Place")
    @pending_menu_edits = @change_logs.where(changeable_type: "Menu")

    @pending_places = Place.where(approved: false)
    @pending_places.each do |place|
      place.creator = @users.find(place.contributors.first)
      place.save
    end

    @pending_products = Product.where(approved: false)
    @pending_product_edits = @change_logs.where(changeable_type: "Product")
                                         .where("NOT EXISTS (SELECT 1 FROM jsonb_object_keys(data) AS key WHERE key = 'action')")
    @pending_product_edits.each do |product_edit|
      product_edit.shops = Shop.where(id: product_edit.shop_ids)
      product_edit.product_category = ProductCategory.find(product_edit.product_category_id)
      product_edit.brand = Brand.find(product_edit.brand_id)
    end
    @products_requested_for_deletion = @change_logs.where(changeable_type: "Product").where("data ->> 'action' = ?", "Delete")

    @pending_menus = Menu.where(approved: false)
    @pending_reviews = Review.where(approved: false)
    @pending_place_reviews = @pending_reviews.where(reviewable_type: "Place")
    @pending_product_reviews = @pending_reviews.where(reviewable_type: "Product")
  end

  def approve_claim
    claim = Claim.find(params[:id])
    user = claim.user
    place = claim.place

    user.places << place
    user.role = "place_owner"

    claim.status = "approved"

    if user.save! && user.places.include?(place) && claim.destroy
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Talep onaylandı."
          render turbo_stream: [
            turbo_stream.remove("claim_#{params[:id]}"),
            turbo_stream.update("flash_messages", partial: "shared/flash_messages", locals: { flash: })
          ]
        end
      end
    else
      redirect_to approvals_path, alert: "Talep onaylanamadı."
    end
  end

  def reject_claim
    claim = Claim.find(params[:id])
    claim.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Talep reddedildi."
        render turbo_stream: [ turbo_stream.remove("claim_#{params[:id]}"),
                              turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                  locals: { flash: }) ]
      end
    end
  end

  def approve_user
    user = User.find(params[:id])
    user.approve
    if user.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Kullanıcı onaylandı."
          render turbo_stream: [
            turbo_stream.remove("user_#{params[:id]}"),
            turbo_stream.update("flash_messages", partial: "shared/flash_messages", locals: { flash: })
          ]
        end
      end
    else
      redirect_to approvals_path, alert: "Kullanıcı onaylanamadı."
    end
  end

  def approve_place
    place = Place.find(params[:id])
    place.approve
    creator = User.find(place.contributors.first)
    creator.points += 10
    if place.save && creator.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Mekan onaylandı"
          render turbo_stream: [
            turbo_stream.remove("place_#{params[:id]}"),
            turbo_stream.update("flash_messages", partial: "shared/flash_messages", locals: { flash: })
          ]
        end
      end
    else
      redirect_to approvals_path, alert: "Mekan onaylanamadı"
    end
  end

  def reject_place
    place = Place.find(params[:id])
    place.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Mekan reddedildi."
        render turbo_stream: [ turbo_stream.remove("place_#{params[:id]}"),
                              turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                  locals: { flash: }) ]
      end
    end
  end

  def approve_place_edit
    place_edit = ChangeLog.find(params[:id])
    if place_edit.approve_place_edit
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Mekan düzenlemesi onaylandı"
          render turbo_stream: [ turbo_stream.remove("place_edit_#{place_edit.id}"),
                                turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                    locals: { flash: }) ]
        end
      end
    else
      redirect_to approvals_path, alert: "Mekan düzenlemesi onaylanamadı"
    end
  end

  def reject_place_edit
    place_edit = ChangeLog.find(params[:id])
    place_edit.destroy

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Mekan düzenlemesi reddedildi"
        render turbo_stream: [ turbo_stream.remove("place_edit_#{place_edit.id}"),
                              turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                  locals: { flash: }) ]
      end
    end
  end

  def approve_product
    product = Product.find(params[:id])
    product.approve
    if product.save
      product.contributors.first.user.points += 10
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Ürün onaylandı"
          render turbo_stream: [ turbo_stream.remove("product_#{params[:id]}"),
                                turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                    locals: { flash: }) ]
        end
      end
    else
      redirect_to approvals_path, alert: "Ürün onaylanamadı"
    end
  end

  def reject_product
    product = Product.find(params[:id])
    product.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Ürün reddedildi"
        render turbo_stream: [ turbo_stream.remove("product_#{params[:id]}"),
                              turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                  locals: { flash: }) ]
      end
    end
  end

  def approve_product_edit
    product_edit = ChangeLog.find(params[:id])
    if product_edit.approve_product_edit
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Ürün düzenlemesi onaylandı"
          render turbo_stream: [ turbo_stream.remove("product_edit_#{product_edit.id}"),
                                turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                    locals: { flash: }) ]
        end
      end
    else
      redirect_to approvals_path, alert: "Ürün düzenlemesi onaylanamadı"
    end
  end

  def reject_product_edit
    product_edit = ChangeLog.find(params[:id])
    product_edit.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Ürün düzenlemesi reddedildi"
        render turbo_stream: [ turbo_stream.remove("product_edit_#{product_edit.id}"),
                              turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                  locals: { flash: }) ]
      end
    end
  end

  def approve_menu
    menu = Menu.find(params[:id])
    place = menu.place
    menu.approve
    menu.creator.points += 5

    unless place.contributors.include?(menu.creator.id)
      place.contributors << menu.creator.id
      place.save
    end

    if menu.save && menu.creator.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Menü onaylandı"
          render turbo_stream: [ turbo_stream.remove("menu_#{params[:id]}"),
                                turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                    locals: { flash: }) ]
        end
      end
    else
      redirect_to approvals_path, alert: "Menü onaylanamadı"
    end
  end

  def reject_menu
    menu = Menu.find(params[:id])
    menu.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Menü reddedildi"
        render turbo_stream: [ turbo_stream.remove("menu_#{params[:id]}"),
                              turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                  locals: { flash: }) ]
      end
    end
  end

  def approve_menu_edit
    menu_edit = ChangeLog.find(params[:id])
    if menu_edit.approve_menu_edit
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Menü düzenlemesi onaylandı"
          render turbo_stream: [ turbo_stream.remove("menu_edit_#{menu_edit.id}"),
                                turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                    locals: { flash: }) ]
        end
      end
    else
      redirect_to approvals_path, alert: "Menü düzenlemesi onaylanamadı"
    end
  end

  def reject_menu_edit
    menu_edit = ChangeLog.find(params[:id])
    menu_edit.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Menü düzenlemesi reddedildi"
        render turbo_stream: [ turbo_stream.remove("menu_edit_#{menu_edit.id}"),
                              turbo_stream.update("flash_messages", partial: "shared/flash_messages",
                                                  locals: { flash: }) ]
      end
    end
  end

  def approve_review
    @review = Review.find(params[:id])
    @review.approve
    @review.user.points += 2
    if @review.user.save && @review.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Değerlendirme onaylandı"
        end
      end
    else
      redirect_to approvals_path, alert: "Değerlendirme onaylanamadı"
    end
  end

  def reject_review
    @review = Review.find(params[:id])
    @review.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Değerlendirme reddedildi"
      end
    end
  end

  def edit_note_form
    @user = User.find(params[:id])
  end

  def update_note
    @user = User.find(params[:id])
    @user.admin_note = params[:user][:admin_note]
    if @user.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Not güncellendi."
          render turbo_stream: [
            turbo_stream.replace("note_#{params[:id]}", partial: "admins/user_note", locals: { user: @user }),
            turbo_stream.update("flash_messages", partial: "shared/flash_messages", locals: { flash: })
          ]
        end
      end
    else
      flash.now[:alert] = "Not güncellenemedi."
      render turbo_stream: turbo_stream.update("flash_messages", partial: "shared/flash_messages", locals: { flash: })
    end
  end

  private

  def authenticate_admin
    redirect_to root_path unless user_signed_in? && current_user.admin?
  end
end
