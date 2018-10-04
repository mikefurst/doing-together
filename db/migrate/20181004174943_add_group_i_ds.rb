class AddGroupIDs < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :groupid, :integer
  end
end
