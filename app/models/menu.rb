class Menu < ApplicationRecord
  attr_accessor :creator

  belongs_to :place
  has_many :change_logs, as: :changeable, dependent: :destroy
  has_many :likes, as: :record, dependent: :destroy

  has_one_attached :image, dependent: :destroy

  enum product_category: { Yemek: 0, Tatlı: 1, İçecek: 2 }

  def approve
    self.approved = true
    save
  end

  def liked_by?(user)
    likes.where(user:).any?
  end

  def like(user)
    likes.where(user:).first_or_create
  end

  def unlike(user)
    likes.where(user:).destroy_all
  end
end
