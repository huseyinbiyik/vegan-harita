class Menu < ApplicationRecord
  belongs_to :place

  enum product_category: { food: 0, dessert: 1, drink: 2 }
end
