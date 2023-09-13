class ChangeLog < ApplicationRecord
  belongs_to :changeable, polymorphic: true
end
