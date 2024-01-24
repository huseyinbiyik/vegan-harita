class ChangeLog < ApplicationRecord
  # Associations
  belongs_to :changeable, polymorphic: true
  belongs_to :user
  has_many_attached :images
  has_one_attached :image

  # Validations
  validates :user_id, presence: true
  validates :changeable_id, presence: true
  validates :changeable_type, presence: true

  # JSONB attributes validations
  validates :name, if: -> { changeable_type == "Place" && name.present? }, length: { minimum: 2, maximum: 80 }
  # This place_id comes from Google Places API
  validates :place_id, length: { minimum: 2, maximum: 80 }, if: lambda { changeable_type == "Place" && address.present? && place_id.present? }
  validates :address, length: { minimum: 15, maximum: 500 }, if: -> { changeable_type == "Place" && address.present? }
  validates :vegan, inclusion: { in: %w[true false] }, unless: -> { vegan.nil? }

  validates :instagram_handle,
            format: { with: /\A[\w.-]+\z/, message: I18n.t("activerecord.attributes.place.instagram_invalid") },
            allow_blank: true,
            length: { maximum: 30 },
            if: -> { instagram_handle.present? }
  validates :facebook_handle,
            format: { with: /\A[\w.-]+\z/, message: I18n.t("activerecord.attributes.place.facebook_invalid") },
            allow_blank: true,
            length: { maximum: 50 },
            if: -> { facebook_handle.present? }
  validates :x_handle,
            format: { with: /\A[\w.-]+\z/, message: I18n.t("activerecord.attributes.place.x_invalid") },
            allow_blank: true,
            length: { maximum: 20 },
            if: -> { x_handle.present? }
  validates :web_url,
            format:
              { with: %r{\A(?!www)(([a-z0-9]+(-[a-z0-9]+)*\.)*[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}(/[a-zA-Z0-9]*)?\z},
                allow_blank: true },
            if: -> { web_url.present? }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true, if: -> { email.present? }
  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true, if: lambda { phone.present? }
  validates :tag_ids, if: -> { tag_ids.present? }, length: { maximum: Tag.count }

  store_accessor :data, :name, :vegan, :latitude, :place_id, :longitude, :address, :phone, :web_url,
                 :email, :facebook_handle, :instagram_handle, :x_handle, :tag_ids, :deleted_images,
                 :description, :product_category, :price, :contributors, :active


  # Public methods
  def place_attributes
    {
      name:,
      longitude:,
      latitude:,
      place_id:,
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

    menu.place.contributors << user.id unless menu.place.contributors.include?(user.id)
    menu.place.save
    menu.save

    user.increment!(:points)

    destroy
  end

  private

    # Private methods
    def check_image
      if image.attached? && !image.content_type.in?(%w[image/jpeg image/png image/jpg image/webp])
        errors.add(:image, I18n.t("activerecord.attributes.menu.image_invalid"))
      elsif image.attached? && image.blob.byte_size > 3.megabytes
        errors.add(:image, I18n.t("activerecord.attributes.menu.image_size"))
      end
    end
end
