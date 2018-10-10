class AddGroupstoActivityTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :activity_types, :groupid, :integer
    add_column :activity_types, :userid, :integer
  end
end