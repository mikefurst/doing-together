class RemoveAdminId < ActiveRecord::Migration[5.0]
  def change
    remove_column :groups, :adminid, :integer
  end
end
