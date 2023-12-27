class Tag < ApplicationRecord
  has_and_belongs_to_many :places
  before_save :downcase_name

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 30 }

  private

  def downcase_name
    name.downcase!
  end
end
