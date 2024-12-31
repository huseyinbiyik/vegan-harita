class PostComment < ApplicationRecord
  include Likeable

  belongs_to :user
  belongs_to :post

  has_rich_text :content

  scope :approved, -> { where(approved: true) }

  def approve
    update(approved: true)
  end

end
