class ChangeLog < ApplicationRecord
  store_accessor :data, :name, :vegan, :latitude, :longitude, :address, :phone, :web_url,
                 :email, :facebook_handle, :instagram_handle, :x_handle, :tag_ids, :deleted_images,
                 :description, :product_category, :price, :contributors, :active
  belongs_to :changeable, polymorphic: true
  belongs_to :user
  has_many_attached :images
  has_one_attached :image

  def place_attributes
    {
      name:,
      longitude:,
      latitude:,
      address:,
      vegan:,
      instagram_handle:,
      facebook_handle:,
      x_handle:,
      web_url:,
      email:,
      phone:
    }
  end

  def approve_place_edit
    place = Place.find(changeable_id)

    place.assign_attributes(place_attributes.compact)

    place.tag_ids = tag_ids if tag_ids.present?
    place.images.attach(images.map(&:blob)) if images.attached?

    if deleted_images.present?
      deleted_images.each do |image|
        place.images.find(image).purge
      end
    end

    place.contributors << user.id unless place.contributors.include?(user.id)
    place.save

    user.increment!(:points)

    destroy
  end

  def menu_attributes
    {
      name:,
      description:,
      product_category:,
      price:,
      active:
    }
  end

  def approve_menu_edit
    menu = Menu.find(changeable_id)

    menu.assign_attributes(menu_attributes.compact)

    menu.image.attach(image.blob) if image.attached?

    menu.save

    user.increment!(:points)

    destroy
  end
end
