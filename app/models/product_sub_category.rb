class ProductSubCategory < ApplicationRecord
  # Translations
  extend Mobility
  translates :name, type: :string

  # Associations
  belongs_to :product_category
  has_many :products

  # Validations
  validates :name, presence: true, length: { maximum: 200 }
end
