class ChangeLogsController < ApplicationController
  before_action :authenticate_user!

  def new
    @change_log = ChangeLog.new
  end

  def create
    @change_log = ChangeLog.new(change_log_params)
    @change_log.user = current_user

    if @change_log.save
      redirect_to root_path, notice: t(".success")
    else
      render :new
    end
  end

  private

  def change_log_params
    params.require(:change_log).permit(:changeable_id, :changeable_type, :user_id, :action, :request_message)
  end
end
