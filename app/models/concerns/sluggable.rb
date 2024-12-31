module Sluggable
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_source_attribute
    before_validation :assign_slug, on: :create
    before_save :assign_slug, if: -> { send("#{slug_source_attribute}_changed?") }
    validates :slug, uniqueness: true
  end

  class_methods do
    def slugify(attribute)
      self.slug_source_attribute = attribute
    end
  end

  def create_slug
    source_value = send(slug_source_attribute)
    if self.class.where(slug: source_value.parameterize).exists?
      "#{source_value.parameterize}-#{SecureRandom.hex(4)}"
    else
      source_value.parameterize
    end
  end

  def to_param
    slug
  end

  private

    def assign_slug
      self.slug = create_slug
    end
end
