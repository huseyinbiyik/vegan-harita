class HomeController < ApplicationController
  prepend_before_action :check_captcha, only: [ :send_mail ], if: -> { Rails.env.production? }

  def contact
    @contact_params = { name: "", email: "", message: "", gender: "", images: [] }
  end

  def send_mail
    contact_params = validate_params
    if contact_params
      ContactMailer.contact_email(contact_params[:name], contact_params[:email], contact_params[:message],
                                  contact_params[:images]).deliver_now
      redirect_to contact_path, notice: t("controllers.home.message_received")
    else
      @contact_params = params.permit(:name, :email, :message, :gender, images: [])

      flash.now[:alert] = t("controllers.home.invalid_data")
      render :contact
    end
  end

  private

  def check_captcha
    return if verify_recaptcha

    @contact_params = params.permit(:name, :email, :message, :gender, images: [])

    flash.now[:alert] = t(:captcha_error)
    render :contact
  end

  def validate_params
    sanitized_params = params.permit(:name, :email, :message, :gender, images: [])
    return false if sanitized_params[:name].length > 50
    return false if sanitized_params[:email].length > 50
    return false if sanitized_params[:message].length > 2000
    return false if sanitized_params[:images].length > 5
    return false if sanitized_params[:images].any? { |image| image.size > 5.megabytes }
    # Honeypot field
    return false unless sanitized_params[:gender].blank?

    sanitized_params
  end
end
