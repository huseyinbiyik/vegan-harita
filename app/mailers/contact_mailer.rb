class ContactMailer < ApplicationMailer
  def contact_email(name, email, message, images)
    @name = name
    @email = email
    @message = message

    images.each do |image|
      attachments[image.original_filename] = File.read(image.tempfile) if image.present?
    end

    mail(to: 'iletisim@veganharita.com', subject: 'New Contact Form Submission')
  end
end
