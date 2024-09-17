# Preview all emails at http://localhost:3000/rails/mailers/product_mailer
class ProductMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/product_mailer/new_product_added
  def new_product_added
    ProductMailer.with(product: Product.first, user: User.first).new_product_added
  end
end
