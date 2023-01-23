class Place < ApplicationRecord
  # geocoded_by :address
  # after_validation :geocode

  # Has many menu items
  has_many :menus, dependent: :destroy

  # Add images to the gallery
  has_many_attached :images

  # For the search area
  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
end
