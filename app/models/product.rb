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
  has_many :contributors, as: :contributable
  has_one_attached :image, dependent: :destroy do |attachable|
    attachable.variant :big, resize_to_limit: [ 500, 500 ]
    attachable.variant :medium, resize_to_limit: [ 250, 250 ]
  end
  has_rich_text :statement

  # Validations

  # Scopes
  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: false) }
  scope :with_contributors, -> { includes(contributors: :user) }
  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }

    # Callbacks
    before_validation :assign_slug, on: :create
    before_save :assign_slug, if: :name_changed?

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

  private


  def assign_slug
    self.slug = create_slug
  end
end
