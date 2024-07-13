class Product < ApplicationRecord
  # Translations
  extend Mobility
  translates :name, type: :string
  translates :ingredients, type: :text

  # Associations
  has_many :change_logs, as: :changeable, dependent: :destroy
  belongs_to :brand
  belongs_to :product_category
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

  def self.ransackable_associations(auth_object = nil)
    %w[brand change_logs contributors image_attachment image_blob product_category rich_text_statement shops]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name ingredients bar_code]
  end

  # Public methods
  def approve
    self.approved = true
    save
  end
end
