class AddGroupAdminId < ActiveRecord::Migration[5.0]
  def change
      add_column :groups, :adminid, :integer
  end
end
