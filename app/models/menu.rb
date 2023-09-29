class Menu < ApplicationRecord
  attr_accessor :creator

  belongs_to :place
  has_many :change_logs, as: :changeable, dependent: :destroy

  has_one_attached :image, dependent: :destroy

  enum product_category: { Yemek: 0, Tatlı: 1, İçecek: 2 }

  def approve
    self.approved = true
    save
  end
end
