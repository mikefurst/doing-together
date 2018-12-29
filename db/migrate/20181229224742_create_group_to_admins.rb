class CreateGroupToAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :group_to_admins do |t|
      t.integer :groupid
      t.integer :userid
      t.timestamps
    end
  end
end
