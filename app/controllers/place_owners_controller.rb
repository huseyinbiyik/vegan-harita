class PlaceOwnersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @places = current_user.places
  end

  def navigation
    @place = Place.find(params[:place_id])
  end

  def summary
    @place = Place.find(params[:place_id])
  end

  def feedback
    @place = Place.find(params[:place_id])
  end
end
