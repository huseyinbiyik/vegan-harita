class ProductMailer < ApplicationMailer
  def new_product_added
    @product = params[:product]
    @user = params[:user]
    @url = product_url(@product.slug)

    mail(to: @user.email, subject: I18n.t(".new_product_added_subject", contributor: @product.contributors.first.user.username), locale: @user.locale)
  end
end
