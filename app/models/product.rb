class Product < ApplicationRecord
  extend Mobility
  translates :name, type: :string
  translates :ingredients, type: :text
end
