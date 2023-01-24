class Menu < ApplicationRecord
  belongs_to :place

  has_many_attached :menu_images

  enum product_category: { food: 0, dessert: 1, drink: 2 }
end
