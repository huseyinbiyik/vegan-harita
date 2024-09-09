class ProductNotificationJob < ApplicationJob
  queue_as :default

  def perform(product)
    users = User.where(allow_product_notification: true)
    users.each do |user|
      ProductMailer.with(product: product, user: user).new_product_added.deliver_later
    end
  end
end
