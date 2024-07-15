class ProductSubCategory < ApplicationRecord
  # Translations
  extend Mobility
  translates :name, type: :string

  # Associations
  belongs_to :product_category
  has_many :products
end
