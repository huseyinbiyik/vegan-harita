class HomeController < ApplicationController
  prepend_before_action :check_captcha, only: [:send_mail]
  def contact; end

  def send_mail
    ContactMailer.contact_email(params[:name], params[:email], params[:message], params[:images]).deliver_now
    redirect_to contact_path, notice: t('controllers.home.message_received')
  end

  private

  def check_captcha
    return if verify_recaptcha

    redirect_to contact_path, alert: t(:captcha_error)
  end
end
