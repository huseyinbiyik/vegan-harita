class Menu < ApplicationRecord
  belongs_to :place

  has_many_attached :menu_images

  enum product_category: { Yemek: 0, Tatlı: 1, İçecek: 2 }
end
