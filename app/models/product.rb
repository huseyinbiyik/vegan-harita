class Product < ApplicationRecord
  # Translations
  extend Mobility
  translates :name, type: :string
  translates :ingredients, type: :text

  # Associations
  belongs_to :brand
  belongs_to :product_category
  has_and_belongs_to_many :shops
  has_one_attached :image, dependent: :destroy do |attachable|
    attachable.variant :big, resize_to_limit: [ 500, 500 ]
    attachable.variant :medium, resize_to_limit: [ 250, 250 ]
  end
  has_rich_text :statement

  # Validations
end
