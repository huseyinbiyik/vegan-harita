class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  helper_method :extract_locale_from_accept_language_header

  private

  def set_locale
    I18n.locale = current_user&.locale || extract_locale_from_accept_language_header || I18n.default_locale
  end

  def extract_locale_from_accept_language_header
    accept_language = request.env["HTTP_ACCEPT_LANGUAGE"]
    accept_language&.scan(/^[a-z]{2}/)&.first
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[email password password_confirmation user_agreement_accepted username])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [ :approved, :role, :points, :avatar, :locale, :admin_note, :username ])
  end
end
