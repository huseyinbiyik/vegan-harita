class ProductMailer < ApplicationMailer
  def new_product_added
    @product = params[:product]
    @user = params[:user]
    @url = product_url(@product.slug)
    attachments.inline["logo.svg"] = Rails.root.join("app", "assets", "images", "logo.svg").read
    attachments.inline["envelope.svg"] = Rails.root.join("app", "assets", "images", "envelope.svg").read
    attachments.inline["instagram.svg"] = Rails.root.join("app", "assets", "images", "instagram.svg").read


    mail(to: @user.email, subject: I18n.t(".new_product_added_subject", contributor: @product.contributors.first.user.username), locale: @user.locale)
  end
end
