class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }, allow_blank: true
  validates :user_agreement_accepted, acceptance: true
  validates :username, presence: true, uniqueness: true, length: { maximum: 20 }, format: { with: /\A[a-zA-Z0-9]+\Z/ }
  validate :username_is_not_a_route



  has_many :change_logs, dependent: :destroy
  has_many :menus, dependent: :destroy, foreign_key: "creator_id"
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
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

  private

  def avatar_file_type
    return unless avatar.attached? && !avatar.content_type.in?("image/png, image/jpeg, image/jpg")

    errors.add(:avatar, "Incorrect file format! Only jpg and png types are acceptable.")
  end

  def username_is_not_a_route
    routes = Rails.application.routes.routes.map do |route|
      route.path.spec.to_s.split("/")[1]
    end.uniq.compact

    if routes.include?(username)
      errors.add(:username, "is not allowed!")
    end
  end
end
