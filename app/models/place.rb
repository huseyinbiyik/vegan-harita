class Place < ApplicationRecord
  validates :instagram_url, format: { with: %r{\Ahttps?://(www\.)?instagram\.com/[\w-]+/?\z}i }, allow_blank: true

  validates :facebook_url, format: { with: %r{\Ahttps?://(www\.)?facebook\.com/}i }, allow_blank: true

  validates :twitter_url, format: { with: %r{\Ahttps?://(www\.)?twitter\.com/[\w-]+/?\z}i }, allow_blank: true

  validates :web_url, format: { with: %r{\A(https?://)?(.+\.)?[^./]+\.[^./]+\z}i }, allow_blank: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true

  validate :images_count_within_limit

  has_many :place_edits, dependent: :destroy
  has_many :menus, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  has_and_belongs_to_many :tags

  scope :approved, -> { where(approved: true) }

  def featured_image
    images.attached? ? images.first : '../default-place-image.jpeg'
  end

  # For the search area
  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  # Last 10 places
  def self.last_ten
    order(created_at: :desc).limit(10)
  end

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
