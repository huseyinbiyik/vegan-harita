class Menu < ApplicationRecord
  belongs_to :place

  has_many_attached :menu_images

  enum product_category: { yemek: 0, tatlı: 1, içecek: 2 }
end
