class Tag < ApplicationRecord
  has_and_belongs_to_many :places
end
