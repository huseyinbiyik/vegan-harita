class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  has_many_attached :images, dependent: :destroy do |attachable|
    attachable.variant :medium, resize_to_limit: [ 240, 240 ]
  end

  validate :images_count_within_limit

  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :content, presence: true, length: { minimum: 5, maximum: 500 }
  validates :feedback, length: { maximum: 500 }

  scope :approved, -> { where(approved: true) }

  def approve
    self.approved = true
    save
  end

  private

  def images_count_within_limit
    errors.add(:images, "Şu an için en fazla 5 fotoğraf ekleyebilirsiniz 😞") if images.count > 5
    images.each do |image|
      if image.byte_size > 10.megabytes
        errors.add(:images,
                   "Fotoğrafların her birinin boyutu 3MB'dan daha fazla olmamalı 😞.")
      end
    end
  end
end
