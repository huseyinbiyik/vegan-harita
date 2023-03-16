class Place < ApplicationRecord
  validates :instagram_url, format: { with: %r{\Ahttps?://(www\.)?instagram\.com/[\w-]+/?\z}i }, allow_blank: true

  validates :facebook_url, format: { with: %r{\Ahttps?://(www\.)?facebook\.com/}i }, allow_blank: true

  validates :twitter_url, format: { with: %r{\Ahttps?://(www\.)?twitter\.com/[\w-]+/?\z}i }, allow_blank: true

  validates :web_url, format: { with: %r{\A(https?://)?(www\.)?[\w-]+\.[\w-]+\z}i }, allow_blank: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true

  validate :images_count_within_limit

  # geocoded_by :address
  # after_validation :geocode

  # Has many menu items
  has_many :menus, dependent: :destroy

  # Add place images and default image
  has_many_attached :images
  after_commit :add_default_image, on: [:create]

  def add_default_image
    return if images.attached?

    images.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default-place-image.jpeg')),
                  filename: 'default-image.png', content_type: 'image/png')
  end

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
