class AdminsController < ApplicationController
  before_action :authenticate_admin

  def user_approvals
    @users = User.where(approved: false).order('points DESC')
  end

  def approve_user
    user = User.find(params[:id])
    user.approved = true
    places = Place.where(approved: false, contributors: [user.id])
    places.each do |place|
      place.approved = true
      place.save
    end
    user.save
    redirect_to user_approvals_path
  end

  def approve_place
    @place = Place.find(params[:id])
    @place.approved = true
    respond_to do |format|
      if @place.save
        format.html do
          redirect_to place_approvals_path,
                      notice: 'Mekan onaylandı.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def reject_place
    @place = Place.find(params[:id])
    @place.destroy
    respond_to do |format|
      format.html do
        redirect_to place_approvals_path,
                    notice: 'Mekan reddedildi.'
      end
    end
  end

  def approve_place_edit
    @place_edits = PlaceEdit.where(user: User.where(approved: true)).includes(:place).order('created_at DESC')
    @pending_places = Place.where(approved: false)
    @users = User.all
    @pending_places.each do |place|
      place.creator = @users.find(place.contributors.first)
      place.save
    end
    @pending_places = @pending_places.select { |place| place.creator.approved == true }
  end

  private

  def authenticate_admin
    redirect_to root_path unless user_signed_in? && current_user.role == 'admin'
  end
end
