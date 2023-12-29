class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }, allow_blank: true

  has_many :change_logs
  has_many :reviews
  has_many :likes
  has_one_attached :avatar, dependent: :destroy

  validate :avatar_file_type

  enum role: { user: 0, admin: 1 }

  def approve
    self.approved = true
    save
  end

  def admin?
    role == "admin"
  end

  def avatar_file_type
    return unless avatar.attached? && !avatar.content_type.in?("image/png, image/jpeg, image/jpg")

    errors.add(:avatar, "Incorrect file format! Only jpg and png types are acceptable.")
  end
end
