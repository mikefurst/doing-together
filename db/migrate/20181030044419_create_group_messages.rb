class CreateGroupMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :group_messages do |t|
      t.integer :userid
      t.integer :groupid
      t.string :message
      t.timestamps
    end
  end
end
