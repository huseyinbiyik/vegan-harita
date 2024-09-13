class Menu < ApplicationRecord
  # Enums
  enum product_category: { meal: 0, dessert: 1, drink: 2 }

  # Associations
  belongs_to :place
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :change_logs, as: :changeable, dependent: :destroy
  has_many :likes, as: :record, dependent: :destroy
  has_one_attached :image, dependent: :destroy do |attachable|
    attachable.variant :medium, resize_to_limit: [ 400, 400 ]
  end

  # Validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 500 }
  validates :product_category, presence: true, inclusion: { in: %w[meal dessert drink] }
  validates :place_id, presence: true
  validates :creator_id, presence: true
  validates :approved, inclusion: { in: [ true, false ] }, allow_nil: false
  validates :active, inclusion: { in: [ true, false ] }, allow_nil: false
  validate :check_image
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :food, -> { where(product_category: 0, approved: true, active: true).order(likes_count: :desc) }
  scope :dessert, -> { where(product_category: 1, approved: true, active: true).order(likes_count: :desc) }
  scope :drink, -> { where(product_category: 2, approved: true, active: true).order(likes_count: :desc) }

  # Public instance methods
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
    max_likes = place.menus.where(approved: true, active: true).maximum(:likes_count)
    likes_count == max_likes && likes_count >= 5 && self.approved && self.active
  end

  private

  # Private methods
  def check_image
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/png image/jpg image/webp])
      errors.add(:image, I18n.t("activerecord.attributes.menu.image_invalid"))
    elsif image.attached? && image.blob.byte_size > 5.megabytes
      errors.add(:image, I18n.t("activerecord.attributes.menu.image_size"))
    end
  end
end
