class PlaceOwnersController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @places = current_user.places
  end

  def navigation
        @place = Place.find_by(slug: params[:slug])
  end

  def summary
        @place = Place.find_by(slug: params[:slug])
  end

  def feedback
        @place = Place.find_by(slug: params[:slug])
  end
end
