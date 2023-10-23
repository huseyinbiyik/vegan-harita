class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :place_edits, dependent: :destroy
  has_many :change_logs, dependent: :destroy
  has_many :reviews, dependent: :destroy

  enum role: { user: 0, admin: 1 }

  def approve
    self.approved = true
    save
  end
end
