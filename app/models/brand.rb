class Brand < ApplicationRecord
  # Associations
  has_many :products

  # Validations
  validates :name, presence: true, length: { maximum: 200 }
end
