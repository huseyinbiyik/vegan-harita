Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.dig(:google, :recaptcha_site_key)
  config.secret_key = Rails.application.credentials.dig(:google, :recaptcha_secret_key)
end
