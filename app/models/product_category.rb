class ProductCategory < ApplicationRecord
  # Translations
  extend Mobility
  translates :name, type: :string

  # Associations
  has_many :products
  has_many :product_sub_categories
end
