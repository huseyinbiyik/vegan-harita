class ChangeApprovedToEnumInPlaces < ActiveRecord::Migration[7.1]
  def up
    rename_column :places, :approved, :status
    change_column_default :places, :status, nil
    change_column :places, :status, :integer, using: 'status::integer'
    change_column_default :places, :status, 0
  end

  def down
    change_column_default :places, :status, nil
    change_column :places, :status, :boolean, using: 'status::boolean'
    change_column_default :places, :status, false
    rename_column :places, :status, :approved
  end
end
