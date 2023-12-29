class Place < ApplicationRecord
  attr_accessor :creator

  validates :name, presence: true, length: { maximum: 80 }
  validates :address, presence: true, length: { maximum: 500 }, uniqueness: true
  validates :place_id, presence: true, uniqueness: true
  validates :vegan, inclusion: { in: [true, false] }, allow_nil: false
  validates :instagram_handle,
            format: { with: /\A[\w.-]+\z/, message: I18n.t('activerecord.attributes.place.instagram_invalid') },
            allow_blank: true,
            length: { maximum: 30 }
  validates :facebook_handle,
            format: { with: /\A[\w.-]+\z/, message: I18n.t('activerecord.attributes.place.facebook_invalid') },
            allow_blank: true,
            length: { maximum: 50 }
  validates :x_handle,
            format: { with: /\A[\w.-]+\z/, message: I18n.t('activerecord.attributes.place.x_invalid') },
            allow_blank: true,
            length: { maximum: 50 }
  validates :web_url,
            format:
              { with: %r{\A(?!www)(([a-z0-9]+(-[a-z0-9]+)*\.)*[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}(/[a-zA-Z0-9]*)?\z},
                allow_blank: true }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true
  validate :images_count_within_limit
  validate :images_type

  has_many :change_logs, as: :changeable, dependent: :destroy
  has_many :menus, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :reviews, dependent: :destroy

  scope :approved, -> { where(approved: true) }

  def featured_image
    return unless images.attached?

    Rails.application.routes.url_helpers.rails_blob_path(images.first, only_path: true)
  end

  # For the search area
  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  def approve
    self.approved = true
  end

  private

  def images_type
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(%('image/jpeg image/png image/jpg image/webp'))
        errors.add(:images,
                   I18n.t('activerecord.attributes.place.image_invalid'))
      end
    end
  end

  # Validation for adding images to place on add new form
  def images_count_within_limit
    errors.add(:images, I18n.t('max_image_limit', count: 10)) if images.count > 10
    images.each do |image|
      if image.byte_size > 3.megabytes
        errors.add(:images,
                   I18n.t('activerecord.attributes.place.image_size_invalid'))
      end
    end
  end
end
