class Claim < ApplicationRecord
  belongs_to :user
  belongs_to :place

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, format: { with: /\A[0-9]{3}[0-9]{3}[0-9]{2}[0-9]{2}\z/i }, allow_blank: true
  validates :role, presence: true, length: { maximum: 100 }
  validates :linkedin, length: { maximum: 100 }, allow_blank: true
  validates :note, length: { maximum: 500 }, allow_blank: true
end
