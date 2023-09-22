class Menu < ApplicationRecord
  attr_accessor :creator

  belongs_to :place
  has_many :change_logs, as: :changeable, dependent: :destroy

  has_many_attached :menu_images, dependent: :destroy

  enum product_category: { Yemek: 0, Tatlı: 1, İçecek: 2 }
end
