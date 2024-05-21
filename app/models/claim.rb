class Claim < ApplicationRecord
  belongs_to :user
  belongs_to :place

  # Enums
  enum status: { pending: 0, approved: 1, rejected: 2 }

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true
  validates :role, presence: true, length: { maximum: 100 }
  validates :linkedin, length: { maximum: 100 }, allow_blank: true
  validates :note, length: { maximum: 500 }, allow_blank: true
  validates :status, inclusion: { in: statuses.keys }
end
