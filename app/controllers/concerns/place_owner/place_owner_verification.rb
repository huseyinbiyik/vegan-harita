module PlaceOwner::PlaceOwnerVerification
  extend ActiveSupport::Concern

  included do
    before_action :verify_place_owner
  end

  private

  def verify_place_owner
    return if current_user&.place_owner?

    redirect_to root_path, alert: t(".unauthorized")
  end
end
