class Place < ApplicationRecord

  validates :instagram_url, format: { with: %r{\Ahttps?://(www\.)?instagram\.com/[\w-]+/?\z}i }, allow_blank: true

  validates :facebook_url, format: { with: %r{\Ahttps?://(www\.)?facebook\.com/[\w-]+\z}i }, allow_blank: true

  validates :twitter_url, format: { with: %r{\Ahttps?://(www\.)?twitter\.com/[\w-]+\z}i }, allow_blank: true

  validates :web_url, format: { with: %r{\Ahttps?://(www\.)?[\w-]+\z}i }, allow_blank: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true

  # geocoded_by :address
  # after_validation :geocode

  # Has many menu items
  has_many :menus, dependent: :destroy

  # Add images to the gallery
  has_many_attached :images

  # For the search area
  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
end
