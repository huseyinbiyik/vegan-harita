class Shop < ApplicationRecord
  # Associations
  has_and_belongs_to_many :products

  # Validations
  validates :name, presence: true, length: { maximum: 200 }
end
