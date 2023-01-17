class Place < ApplicationRecord
  # geocoded_by :address
  # after_validation :geocode

  # Place featured image
  has_one_attached :featured_image

  # For the search area
  scope :filter_by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
end
