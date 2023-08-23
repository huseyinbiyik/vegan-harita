class AdminsController < ApplicationController
  before_action :authenticate_admin

  def user_approvals
    @users = User.where(approved: false)
  end

  def approve_user
    user = User.find(params[:id])
    user.approved = true
    user.save
    redirect_to user_approvals_path
  end

  def authenticate_admin
    redirect_to root_path unless user_signed_in? && current_user.role == 'admin'
  end
end
