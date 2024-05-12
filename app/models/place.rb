class Place < ApplicationRecord
  # Accessors
  attr_accessor :creator

  # Callbacks
  before_validation :assign_slug, on: :create
  before_save :assign_slug, if: :name_changed?

  # Associations
  has_many :change_logs, as: :changeable, dependent: :destroy
  has_many :menus, dependent: :destroy
  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags
  has_many :reviews, dependent: :destroy
  has_many :visits, dependent: :destroy
  has_many_attached :images, dependent: :destroy do |attachable|
    attachable.variant :big, resize_to_limit: [ 1000, 1000 ]
    attachable.variant :medium, resize_to_limit: [ 500, 500 ]
  end

  # Validations
  validates :address, presence: true, length: { minimum: 15, maximum: 500 }, uniqueness: true
  validates :place_id, presence: true, uniqueness: true, length: { maximum: 80 }
  validates :name, presence: true, length: { maximum: 100 }
  validates :vegan, inclusion: { in: [ true, false ] }, allow_nil: false
  validates :instagram_handle,
            format: { with: /\A[\w.-]+\z/, message: I18n.t("activerecord.attributes.place.instagram_invalid") },
            allow_blank: true,
            length: { maximum: 30 }
  validates :facebook_handle,
            format: { with: /\A[\w.-]+\z/, message: I18n.t("activerecord.attributes.place.facebook_invalid") },
            allow_blank: true,
            length: { maximum: 50 }
  validates :x_handle,
            format: { with: /\A[\w.-]+\z/, message: I18n.t("activerecord.attributes.place.x_invalid") },
            allow_blank: true,
            length: { maximum: 50 }
  validates :web_url,
            format:
              { with: %r{\A(?!www)(([a-z0-9]+(-[a-z0-9]+)*\.)*[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}(/[a-zA-Z0-9]*)?\z},
                allow_blank: true }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true
  validate :images_count_within_limit
  validate :images_type
  validates :slug, uniqueness: true

  # Scopes
  scope :approved, -> { where(approved: true) }
  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }

  # Public instance methods
  def approve
    self.approved = true
  end

  def featured_image
    return unless images.attached?

    Rails.application.routes.url_helpers.rails_blob_path(images.first.variant(:medium), only_path: true)
  end

  def create_slug
    if Place.where(slug: name.parameterize).exists?
      "#{name.parameterize}-#{address.split(",")[0].parameterize}"
    else
      name.parameterize
    end
  end

  def visits_count_for_current_month
    visits.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).count
  end

  private

  # Private methods
  def assign_slug
    self.slug = create_slug
  end

  def images_type
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(%('image/jpeg image/png image/jpg image/webp'))
        errors.add(:images,
                   I18n.t("activerecord.attributes.place.image_invalid"))
      end
    end
  end

  def images_count_within_limit
    errors.add(:images, I18n.t("max_image_limit", count: 20)) if images.count > 20
    images.each do |image|
      if image.byte_size > 3.megabytes
        errors.add(:images,
                   I18n.t("activerecord.attributes.place.image_size_invalid"))
      end
    end
  end
end
