class ChangeLog < ApplicationRecord
  # Associations
  belongs_to :changeable, polymorphic: true
  belongs_to :user
  has_many_attached :images
  has_one_attached :image
  has_rich_text :statement

  # Validations
  validates :user_id, presence: true
  validates :changeable_id, presence: true
  validates :changeable_type, presence: true

  # JSONB attributes validations
  # Product validations
  validates :request_message, length: { minimum: 5, maximum: 500 }, if: -> { changeable_type == "Product" && request_message.present? }
  # Place validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }, if: -> { changeable_type == "Place" && name.present? }
  validates :address, length: { minimum: 15, maximum: 500 }, if: -> { changeable_type == "Place" && address.present? }
  # This place_id comes from Google Places API
  validates :place_id, length: { minimum: 2, maximum: 80 }, if: lambda { changeable_type == "Place" && address.present? && place_id.present? }
  validates :vegan, inclusion: { in: %w[true false] }, allow_nil: false, if: -> { changeable_type == "Place" && vegan.present? }

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
  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true, if: lambda { phone.present? }
  validates :tag_ids, if: -> { tag_ids.present? }, length: { maximum: Tag.count }
  validate :max_image_limit, if: -> { changeable_type == "Place" && images.attached? }

  # Menu validations
  validates :name, presence: true, length: { maximum: 50 }, if: -> { changeable_type == "Menu" }
  validates :description, length: { maximum: 500 }, if: -> { changeable_type == "Menu" && description.present? }
  validates :product_category, presence: true, inclusion: { in: %w[meal dessert drink] }, if: -> { changeable_type == "Menu" }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, if: -> { changeable_type == "Menu" && price.present? }
  validate :check_image, if: -> { changeable_type == "Menu" && image.attached? }

  # Public instance methods
  store_accessor :data,
                 :action,
                 :request_message,
                 :name,
                 :vegan,
                 :latitude,
                 :place_id,
                 :longitude,
                 :address,
                 :phone,
                 :web_url,
                 :facebook_handle,
                 :instagram_handle,
                 :x_handle,
                 :tag_ids,
                 :deleted_images,
                 :description,
                 :product_category,
                 :price,
                 :contributors,
                 :active,
                 :name_en,
                 :name_tr,
                 :ingredients_en,
                 :ingredients_tr,
                 :brand,
                 :brand_id,
                 :shops,
                 :shop_ids,
                 :product_category_id,
                 :product_sub_category_id,
                 :statement,
                 :bar_code

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

  def product_attributes
    {
      name:,
      ingredients_en:,
      ingredients_tr:,
      brand_id:,
      bar_code:,
      statement:,
      shop_ids:,
      product_category_id:,
      product_sub_category_id:
    }
  end

  def approve_product_edit
    product = Product.find(changeable_id)

    product.assign_attributes(product_attributes.compact)

    product.image.attach(image.blob) if image.attached?

    product.save!

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

  def max_image_limit
    if changeable_type == "Place" && changeable.images.attached?
      errors.add(:images, I18n.t("max_image_limit", count: 20)) if images.count + changeable.images.count > 20
    end
  end
end
