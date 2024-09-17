class Contributor < ActiveRecord::Base
  belongs_to :user
  belongs_to :contributable, polymorphic: true
end
