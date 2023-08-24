class AddContributorsToPlaces < ActiveRecord::Migration[7.0]
  def change
    add_column :places, :contributors, :integer, array: true, default: []
  end
end
