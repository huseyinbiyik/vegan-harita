class AdminsController < ApplicationController
  before_action :authenticate_admin

  def user_approvals
    @users = User.where(approved: false).order('created_at DESC').includes(:place_edits)
    @places = Place.all
    @pending_places = @places.where(approved: false)
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

  def approve_place_edit
    @place_edits = PlaceEdit.all.includes(:place).order('created_at DESC')
  end

  private

  def authenticate_admin
    redirect_to root_path unless user_signed_in? && current_user.role == 'admin'
  end
end