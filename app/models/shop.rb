class Shop < ApplicationRecord
  # Associations
  has_and_belongs_to_many :products

  # Scopes
  default_scope { order(name: :asc) }

  # Validations
  validates :name, presence: true, length: { maximum: 200 }
end
