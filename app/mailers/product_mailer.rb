class ProductMailer < ApplicationMailer
  def new_product_added
    @product = params[:product]
    @user = params[:user]
    @url = product_url(@product.slug)
    attachments.inline["logo.png"] = Rails.root.join("app", "assets", "images", "logo.png").read
    attachments.inline["envelope.png"] = Rails.root.join("app", "assets", "images", "envelope.png").read
    attachments.inline["mailer-instagram.png"] = Rails.root.join("app", "assets", "images", "mailer-instagram.png").read


    mail(to: @user.email, subject: I18n.t(".new_product_added_subject", contributor: @product.contributors.first.user.username), locale: @user.locale)
  end
end
