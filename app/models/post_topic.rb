class PostTopic < ApplicationRecord
  has_many :posts

  validates :title, presence: true, length: { minimum: 5, maximum: 100 }, uniqueness: true
end
