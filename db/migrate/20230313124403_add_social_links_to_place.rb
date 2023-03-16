class AddSocialLinksToPlace < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :instagram_url, :string
    add_column :places, :facebook_url, :string
    add_column :places, :twitter_url, :string
    add_column :places, :web_url, :string
    add_column :places, :email, :string
    add_column :places, :phone, :string
  end
end
