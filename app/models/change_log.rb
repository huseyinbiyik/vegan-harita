class ChangeLog < ApplicationRecord
  store_accessor :data, :name, :vegan, :latitude, :longitude, :address, :phone, :web_url, :email, :facebook_url,
                 :instagram_url, :twitter_url, :tag_ids, :deleted_images
  belongs_to :changeable, polymorphic: true
  belongs_to :user
  has_many_attached :images
end
