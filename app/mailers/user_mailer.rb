class UserMailer < Devise::Mailer
  before_action :attach_images

  private

  def attach_images
    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/logo.png"))
    attachments.inline["instagram.png"] = File.read(Rails.root.join("app/assets/images/instagram.png"))
    attachments.inline["envelope.png"] = File.read(Rails.root.join("app/assets/images/envelope.png"))
  end
end
