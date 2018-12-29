class CreateUserToGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :user_to_groups do |t|
      t.integer :userid
      t.integer :groupid
      t.timestamps
    end
  end
end
