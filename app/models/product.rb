class Product < ApplicationRecord
  # Translations
  extend Mobility
  translates :ingredients, type: :text

  # Associations
  has_many :change_logs, as: :changeable, dependent: :destroy
  belongs_to :brand
  belongs_to :product_category
  belongs_to :product_sub_category
  has_and_belongs_to_many :shops
  has_many :reviews, as: :reviewable
  has_many :contributors, as: :contributable
  has_one_attached :image, dependent: :destroy do |attachable|
    attachable.variant :big, resize_to_limit: [ 500, 500 ]
    attachable.variant :medium, resize_to_limit: [ 250, 250 ]
  end
  has_rich_text :statement

  # Validations
  validates :name, presence: true
  validate :image_size
  validates :bar_code, uniqueness: true, allow_blank: true, length: { minimum: 8, maximum: 40 }
  validates :slug, uniqueness: true
  validates :ingredients, length: { maximum: 5000 }
  validates :statement, length: { maximum: 5000 }
  validate :statement_attachment_size
  validate :must_belong_to_at_least_one_shop

  # Scopes
  default_scope { order(created_at: :desc) }
  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: false) }
  scope :with_contributors, -> { includes(contributors: :user) }
  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }

  # Callbacks
  before_validation :assign_slug, on: :create
  before_save :assign_slug, if: :name_changed?
  after_create :send_notification_email, if: :approved?
  after_update :send_notification_email, if: -> { saved_change_to_approved? && approved? }

  # Public methods
  def approve
    self.approved = true
    save
  end

  def create_slug
    if Product.where(slug: name.parameterize).exists?
      "#{name.parameterize}-#{SecureRandom.hex(4)}"
    else
      name.parameterize
    end
  end

  ransacker :shop_id do
    Arel.sql("shops.id")
  end

  private


  def assign_slug
    self.slug = create_slug
  end

  def image_size
    if image.attached?
      if image.blob.byte_size > 2.megabytes
        errors.add(:image, :image_too_big)
      end
    end
  end

  def statement_attachment_size
    if statement.body.attachments.any? && statement.body.attachments.first.byte_size > 10.megabytes
      errors.add(:statement, :attachment_too_big)
    end
  end

  def must_belong_to_at_least_one_shop
    if shop_ids.empty?
      errors.add(:shop_ids, :no_selection)
    end
  end

  def send_notification_email
    ProductNotificationJob.perform_later(self)
  end
end
