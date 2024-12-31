class Post < ApplicationRecord
  include Likeable
  include Sluggable
  slugify :title

  belongs_to :user
  belongs_to :post_topic, counter_cache: true
  has_many :post_comments, dependent: :destroy

  has_rich_text :content

  validates :title, presence: true, length: { maximum: 200 }

  scope :approved, -> { where(approved: true) }

  def first_image
    content.embeds.find(&:image?)
  end

  def approve
    update(approved: true)
  end

  private

    def destroy_rich_text_content
      content&.destroy
    end
end
