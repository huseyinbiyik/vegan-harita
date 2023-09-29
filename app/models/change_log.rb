class ChangeLog < ApplicationRecord
  store_accessor :data, :name, :vegan, :latitude, :longitude, :address, :phone, :web_url, :email, :facebook_url,
                 :instagram_url, :twitter_url, :tag_ids, :deleted_images, :description, :product_category, :price, :contributors
  belongs_to :changeable, polymorphic: true
  belongs_to :user
  has_many_attached :images
  has_one_attached :image

  def approve_place_edit
    place = Place.find(changeable_id)

    %w[name longitude latitude address vegan instagram_url facebook_url twitter_url web_url email phone].each do |attr|
      place.send("#{attr}=", send(attr)) if send(attr).present?
    end

    place.tag_ids = tag_ids if tag_ids.present?
    place.images.attach(images.map(&:blob)) if images.attached?

    if deleted_images.present?
      deleted_images.each do |image|
        place.images.find(image).purge
      end
    end

    place.contributors << user.id unless place.contributors.include?(user.id)
    place.save

    user.points += 1
    user.save

    destroy
  end

  def approve_menu_edit
    menu = Menu.find(changeable_id)

    %w[name description product_category price].each do |attr|
      menu.send("#{attr}=", send(attr))
    end

    menu.image.purge if image.attached?
    menu.image.attach(image.blob) if image.attached?

    menu.contributors << user.id unless menu.contributors.include?(user.id)
    menu.save

    user.points += 1
    user.save

    destroy
  end
end
