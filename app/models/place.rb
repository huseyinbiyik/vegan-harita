class Place < ApplicationRecord
  validates :instagram_url, format: { with: %r{\Ahttps?://(www\.)?instagram\.com/[\w-]+/?\z}i }, allow_blank: true

  validates :facebook_url, format: { with: %r{\Ahttps?://(www\.)?facebook\.com/[\w-]+\z}i }, allow_blank: true

  validates :twitter_url, format: { with: %r{\Ahttps?://(www\.)?twitter\.com/[\w-]+\z}i }, allow_blank: true

  validates :web_url, format: { with: %r{\Ahttps?://(www\.)?[\w-]+\z}i }, allow_blank: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true

  validate :images_count_within_limit

  # geocoded_by :address
  # after_validation :geocode

  # Has many menu items
  has_many :menus, dependent: :destroy

  # Add images to the gallery
  has_many_attached :images

  # For the search area
  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  private

  # Validation for adding images to place on add new form
  def images_count_within_limit
    errors.add(:images, 'Şu an için en fazla 10 fotoğraf ekleyebilirsiniz 😞') if images.count > 10
    images.each do |image|
      if image.byte_size > 3.megabytes
        errors.add(:images,
                   "Fotoğrafların her birinin boyutu 3MB'dan daha fazla olmamalı 😞.")
      end
    end
  end
end
