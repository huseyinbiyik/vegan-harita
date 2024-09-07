class ChangeLogsController < ApplicationController
  before_action :authenticate_user!

  def new
    @change_log = ChangeLog.new
    @change_log.changeable_id = params[:changeable_id]
    @change_log.changeable_type = params[:changeable_type]
    @change_log.action = params[:action]
    @change_log.request_message = params[:request_message]
  end

  def create
    @change_log = ChangeLog.new(change_log_params)
    @change_log.user = current_user

    if @change_log.save
      redirect_to root_path, notice: t("success.created", model: ChangeLog.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def change_log_params
    params.require(:change_log).permit(:changeable_id, :changeable_type, :user_id, :action, :request_message)
  end
end
