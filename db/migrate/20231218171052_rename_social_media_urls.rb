class RenameSocialMediaUrls < ActiveRecord::Migration[7.1]
  def change
    rename_column :places, :instagram_url, :instagram_handle
    rename_column :places, :facebook_url, :facebook_handle
    rename_column :places, :twitter_url, :x_handle
  end
end
