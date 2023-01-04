class Place < ApplicationRecord
  # geocoded_by :address
  # after_validation :geocode

  scope :filter_by_name, ->(name) { where('name LIKE ?', "%#{name}%") }
end
