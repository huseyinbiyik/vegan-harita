class Product < ApplicationRecord
  # Translations
  extend Mobility
  translates :name, type: :string
  translates :ingredients, type: :text

  # Associations
  belongs_to :product_category
  has_and_belongs_to_many :shops
end
