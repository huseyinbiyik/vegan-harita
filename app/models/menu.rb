class Menu < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 500 }
  validates :product_category, presence: true, inclusion: { in: %w[Yemek Tatlı İçecek] }
  validates :place_id, presence: true
  validates :creator_id, presence: true
  validates :approved, inclusion: { in: [ true, false ] }, allow_nil: false
  validates :active, inclusion: { in: [ true, false ] }, allow_nil: false
  validate :check_image

  belongs_to :place
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
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

  private

  def check_image
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/png image/jpg image/webp])
      errors.add(:image, I18n.t("activerecord.attributes.menu.image_invalid"))
    elsif image.attached? && image.blob.byte_size > 3.megabytes
      errors.add(:image, I18n.t("activerecord.attributes.menu.image_size"))
    end
  end
end
