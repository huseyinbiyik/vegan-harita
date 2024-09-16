class Brand < ApplicationRecord
  # Associations
  has_many :products

  # Scopes
  default_scope { order(name: :asc) }

  # Validations
  validates :name, presence: true, length: { maximum: 200 }
end
