class ClaimsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  before_action :set_place, only: %i[new create]

  def new
    @claim = Claim.new
  end

  def create
    @claim = Claim.new(claim_params)
    @claim.user = current_user
    @claim.place = @place

    if @claim.save
      redirect_to place_path(@place.slug), notice: t(".claim_submitted")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def claim_params
    params.require(:claim).permit(:name, :phone, :role, :email, :linkedin)
  end

  def set_place
    @place = Place.find_by(slug: params[:place_slug])
  end
end
