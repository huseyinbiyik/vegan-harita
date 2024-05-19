class Claim < ApplicationRecord
  belongs_to :user
  belongs_to :place
end
