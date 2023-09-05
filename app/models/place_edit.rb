class PlaceEdit < ApplicationRecord
  belongs_to :place
  belongs_to :user
  has_many_attached :images
end
