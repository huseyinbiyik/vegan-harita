class Admin::ApplicationController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    redirect_to root_path unless current_user.admin?
  end
end
