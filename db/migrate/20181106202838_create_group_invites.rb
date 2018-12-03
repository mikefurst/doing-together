class CreateGroupInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :group_invites do |t|
      t.integer :groupID
      t.integer :targetID
      t.string :message
      t.timestamps
    end
  end
end
