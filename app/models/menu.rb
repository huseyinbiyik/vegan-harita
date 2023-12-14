class Menu < ApplicationRecord
  belongs_to :place
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :change_logs, as: :changeable, dependent: :destroy
  has_many :likes, as: :record, dependent: :destroy

  has_one_attached :image, dependent: :destroy

  enum product_category: { Yemek: 0, Tatlı: 1, İçecek: 2 }

  scope :food, -> { where(product_category: 0, approved: true, active: true).order(likes_count: :desc) }
  scope :dessert, -> { where(product_category: 1, approved: true, active: true).order(likes_count: :desc) }
  scope :drink, -> { where(product_category: 2, approved: true, active: true).order(likes_count: :desc) }

  def approve
    self.approved = true
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

  def most_liked?(place)
    likes_count == place.menus.maximum(:likes_count) && likes_count >= 5
  end
end
